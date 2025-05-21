from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework import viewsets, status, permissions, generics, serializers
from rest_framework.response import Response
from rest_framework.decorators import action, api_view, permission_classes
from django.utils import timezone
from django.core.files.storage import FileSystemStorage
from django.shortcuts import get_object_or_404
from django.contrib.auth import authenticate, login, update_session_auth_hash
from rest_framework.exceptions import ValidationError
from .models import Asistencia, Reposo, Empleado, Pago, PerfilUsuario, TipoReposo, Permiso, TipoPermiso, Cargo, User, PerfilUsuario, Bono
from .serializers import AsistenciaSerializer, ReposoSerializer, EmpleadoSerializer, PagoSerializer, TipoReposoSerializer, TipoPermisoSerializer, PermisoSerializer, UserSerializer, PerfilUsuarioSerializer, CargoSerializer, EditarUsuarioSerializer, UserBasicSerializer, BonoSerializer
from django.contrib.auth.models import User
from rest_framework.permissions import IsAuthenticated, AllowAny, IsAdminUser
from rest_framework.views import APIView
from rest_framework_simplejwt.views import TokenObtainPairView
from django.db import IntegrityError
from rest_framework.request import Request
from django.core.files.storage import default_storage
import os
import subprocess
from django.http import FileResponse, JsonResponse
from django.contrib.auth.hashers import make_password
from django.db.models.signals import post_save
from django.dispatch import receiver


class BonoListCreateView(generics.ListCreateAPIView):
    queryset = Bono.objects.all()
    serializer_class = BonoSerializer

class BonoDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Bono.objects.all()
    serializer_class = BonoSerializer

# Exportar base de datos
@api_view(['GET'])
def exportar_bd(request):
    ruta_mysqldump = '"C:\\Program Files\\MySQL\\MySQL Server 9.0\\bin\\mysqldump.exe"'
    usuario = 'root'
    contrasena = 'Mely.30.20.10'
    base_datos = 'empleadosdb'
    archivo_salida = 'backup.sql'

    comando = f'{ruta_mysqldump} -u {usuario} -p{contrasena} {base_datos} > {archivo_salida}'

    resultado = subprocess.run(comando, shell=True)
 
    if resultado.returncode != 0:
        return JsonResponse({'error': 'No se pudo exportar la base de datos'}, status=500)

    return FileResponse(open(archivo_salida, 'rb'), as_attachment=True)

# Importar base de datos
@api_view(['POST'])
def importar_bd(request):
    file = request.FILES['archivo']
    filename = default_storage.save('tmp/backup.sql', file)
    filepath = default_storage.path(filename)

    ruta_mysql = r"C:\Program Files\MySQL\MySQL Server 9.0\bin\mysql.exe"
    usuario = 'root'
    contrasena = 'Mely.30.20.10'
    base_datos = 'empleadosdb'

    try:
        with open(filepath, 'rb') as f:
            resultado = subprocess.run(
                [ruta_mysql, '-u', usuario, f'-p{contrasena}', base_datos],
                stdin=f,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE
            )

        if resultado.returncode != 0:
            print("ERROR al importar:", resultado.stderr.decode())  # 👈 Imprime el error aquí
            return JsonResponse({
                'error': 'Error al importar la base de datos',
                'detalle': resultado.stderr.decode('utf-8')
            }, status=500)

        return JsonResponse({'mensaje': 'Base de datos importada correctamente'})

    except Exception as e:
        print("EXCEPCIÓN al importar:", str(e))  # 👈 Imprime la excepción
        return JsonResponse({'error': str(e)}, status=500)


class CambiarPasswordConPreguntas(APIView):
    permission_classes = []  # Sin autenticación

    def post(self, request):
        username = request.data.get('username')
        nueva_password = request.data.get('nueva_password')
        color = request.data.get('color_favorito')
        comida = request.data.get('comida_favorita')
        animal = request.data.get('animal_favorito')

        try:
            user = User.objects.get(username=username)
            PerfilUsuario = user.perfil  # Asumiendo que usas OneToOneField con el modelo Perfil

            if (PerfilUsuario.color_favorito == color and
                PerfilUsuario.comida_favorita == comida and
                PerfilUsuario.animal_favorito == animal):
                user.password = make_password(nueva_password)
                user.save()
                return Response({"detail": "Contraseña actualizada correctamente"}, status=status.HTTP_200_OK)
            else:
                return Response({"detail": "Las respuestas no coinciden"}, status=status.HTTP_400_BAD_REQUEST)

        except User.DoesNotExist:
            return Response({"detail": "Usuario no encontrado"}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"detail": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
def registro(request):
    try:
        username = request.data.get('username')
        password = request.data.get('password')
        email = request.data.get('email')

        if User.objects.filter(username=username).exists():
            return Response({'error': 'El usuario ya existe'}, status=status.HTTP_400_BAD_REQUEST)

        user = User.objects.create(
            username=username,
            email=email,
            password=make_password(password)
        )

        return Response({'mensaje': 'Usuario creado correctamente'}, status=status.HTTP_201_CREATED)

    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
@api_view(['POST'])
@permission_classes([AllowAny])
def cambiar_permiso(request):
    user_id = request.data.get('id')
    is_superuser = request.data.get('is_superuser', False)

    try:
        user = User.objects.get(id=user_id)
        user.is_superuser = is_superuser
        user.save()
        return Response({"detalle": "Permisos actualizados correctamente."})
    except User.DoesNotExist:
        return Response({"error": "Usuario no encontrado."}, status=status.HTTP_404_NOT_FOUND)

@api_view(['GET'])
@permission_classes([AllowAny])
def usuario_actual(request):
    serializer = UserBasicSerializer(request.user)
    return Response(serializer.data)


class UsuarioViewSet(viewsets.ModelViewSet):
    queryset = User.objects.select_related('perfil').all()
    serializer_class = UserBasicSerializer

    def get_serializer_context(self):
        """Añade el request al contexto del serializer para manejar perfiles"""
        context = super().get_serializer_context()
        context['request'] = self.request
        return context

    def perform_create(self, serializer):
        """Crea el perfil cuando se crea un nuevo usuario"""
        user = serializer.save()
        PerfilUsuario.objects.create(user=user)

    def partial_update(self, request, *args, **kwargs):
        """Actualización parcial para usuario y perfil"""
        instance = self.get_object()
        data = request.data.copy()
        
        # Manejo de campos del perfil
        if 'perfil' in data:
            perfil_data = data.pop('perfil')
            perfil = instance.perfil
            
            # Si no existe perfil, lo creamos
            if not hasattr(instance, 'perfil'):
                perfil = PerfilUsuario.objects.create(user=instance)
            
            perfil_serializer = PerfilUsuarioSerializer(
                perfil,
                data=perfil_data,
                partial=True,
                context={'request': request}
            )
            perfil_serializer.is_valid(raise_exception=True)
            perfil_serializer.save()

        # Manejo de campos del usuario
        user_serializer = self.get_serializer(
            instance,
            data=data,
            partial=True
        )
        user_serializer.is_valid(raise_exception=True)
        user_serializer.save()

        return Response(user_serializer.data)

    def destroy(self, request, *args, **kwargs):
        """Elimina usuario y su perfil asociado"""
        instance = self.get_object()
        if hasattr(instance, 'perfil'):
            instance.perfil.delete()
        self.perform_destroy(instance)
        return Response(status=status.HTTP_204_NO_CONTENT)
    
    def list(self, request, *args, **kwargs):
        """Lista usuarios con sus perfiles (optimizado)"""
        queryset = self.filter_queryset(self.get_queryset())
        
        # Debug (puedes eliminar esto en producción)
        for u in queryset:
            perfil = getattr(u, 'perfil', None)
            print(f"Usuario: {u.username}, Perfil: {perfil}")
        
        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_serializer(page, many=True)
            return self.get_paginated_response(serializer.data)
            
        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)

    @action(detail=True, methods=['put'], url_path='permisos')
    def actualizar_permisos(self, request, pk=None):
        """Endpoint específico para actualizar permisos"""
        user = self.get_object()
        data = request.data

        password_actual = data.get('password_actual')
        if not password_actual or not user.check_password(password_actual):
            return Response(
                {'error': 'Contraseña actual incorrecta'},
                status=status.HTTP_400_BAD_REQUEST
            )

        is_superuser = data.get('is_superuser')
        if is_superuser is not None:
            user.is_superuser = is_superuser
            user.save()

        return Response(
            {'mensaje': 'Permisos actualizados'},
            status=status.HTTP_200_OK
        )

class GestionPermisosView(APIView):
    permission_classes = [AllowAny]  # Solo superusuarios pueden acceder

    def post(self, request, *args, **kwargs):
        username = request.data.get('username')
        role = request.data.get('role')  # 'admin' o 'usuario'

        try:
            user = User.objects.get(username=username)
            if role == 'admin':
                user.is_superuser = True
            else:
                user.is_superuser = False
            user.save()
            return Response({"detail": "Permisos actualizados"})
        except User.DoesNotExist:
            return Response({"detail": "Usuario no encontrado"}, status=404)
    
class EditarUsuarioView(APIView):
    permission_classes = [AllowAny]

    def put(self, request, *args, **kwargs):
        user = request.user
        serializer = EditarUsuarioSerializer(user, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class UsuarioDetalleView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, pk):
        try:
            user = User.objects.get(pk=pk)
        except User.DoesNotExist:
            return Response({'error': 'Usuario no encontrado'}, status=404)

        perfil = PerfilUsuario.objects.filter(user=user).first()

        user_data = UserSerializer(user).data
        perfil_data = PerfilUsuarioSerializer(perfil).data if perfil else {}

        return Response({
            'usuario': user_data,
            'perfil': perfil_data
        })
    
class UsuarioActualView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        user = request.user
        perfil = PerfilUsuario.objects.filter(user=user).first()

        user_data = UserSerializer(user).data
        perfil_data = PerfilUsuarioSerializer(perfil).data if perfil else {}

        return Response({
            'usuario': user_data,
            'perfil': perfil_data
        })
class UsuarioDetalleConPerfilView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, id):
        try:
            user = User.objects.get(id=id)
            perfil = PerfilUsuario.objects.filter(user=user).first()

            user_data = UserSerializer(user).data
            perfil_data = PerfilUsuarioSerializer(perfil).data if perfil else {}

            return Response({
                'usuario': user_data,
                'perfil': perfil_data
            })
        except User.DoesNotExist:
            return Response({'error': 'Usuario no encontrado'}, status=status.HTTP_404_NOT_FOUND)

class EditarUsuarioConPerfilView(APIView):
    permission_classes = [AllowAny]

    def put(self, request, id):
        try:
            user = User.objects.get(id=id)
        except User.DoesNotExist:
            return Response({'error': 'Usuario no encontrado'}, status=status.HTTP_404_NOT_FOUND)

        perfil, created = PerfilUsuario.objects.get_or_create(user=user)

        user_data = request.data.get('usuario')
        perfil_data = request.data.get('perfil')

        user_serializer = EditarUsuarioSerializer(user, data=user_data, partial=True)
        perfil_serializer = PerfilUsuarioSerializer(perfil, data=perfil_data, partial=True)

        if user_serializer.is_valid() and perfil_serializer.is_valid():
            user_serializer.save()
            perfil_serializer.save()
            return Response({'usuario': user_serializer.data, 'perfil': perfil_serializer.data})
        else:
            return Response({
                'usuario_errors': user_serializer.errors,
                'perfil_errors': perfil_serializer.errors
            }, status=status.HTTP_400_BAD_REQUEST)

class TipoReposoViewSet(viewsets.ModelViewSet):
    queryset = TipoReposo.objects.all()
    serializer_class = TipoReposoSerializer
    permission_classes = [AllowAny]  # Requiere autenticación

    def get_queryset(self):
        # Si el usuario es un superusuario, puede ver todos los registros
        return TipoReposo.objects.all() 

    @action(detail=False, methods=['get'])
    def active(self, request):
        # Aquí puedes implementar un filtro para obtener tipos de reposo activos, si fuera necesario
        active_tipos = TipoReposo.objects.filter(activo=True)  # Asegúrate de tener un campo "activo" si es necesario
        serializer = self.get_serializer(active_tipos, many=True)
        return Response(serializer.data)

    def create(self, request, *args, **kwargs):
        # Puedes agregar validaciones adicionales si es necesario
        return super().create(request, *args, **kwargs)

    def update(self, request, *args, **kwargs):
        # Agregar lógica adicional si se necesita
        return super().update(request, *args, **kwargs)

    def destroy(self, request, *args, **kwargs):
        # Aquí puedes agregar lógica antes de eliminar un objeto, si es necesario
        return super().destroy(request, *args, **kwargs)
    
class CargoViewSet(viewsets.ModelViewSet):
    queryset = Cargo.objects.all()  # Consulta todos los cargos
    serializer_class = CargoSerializer
    http_method_names = ['get', 'post', 'put', 'delete']
    
class TipoPermisoViewSet(viewsets.ModelViewSet):
    queryset = TipoPermiso.objects.all()
    serializer_class = TipoPermisoSerializer
    permission_classes = [AllowAny]  # Requiere autenticación

    def get_queryset(self):
        # Si el usuario es un superusuario, puede ver todos los registros
        return TipoPermiso.objects.all() 

    @action(detail=False, methods=['get'])
    def active(self, request):
        # Aquí puedes implementar un filtro para obtener tipos de reposo activos, si fuera necesario
        active_tipos = TipoPermiso.objects.filter(activo=True)  # Asegúrate de tener un campo "activo" si es necesario
        serializer = self.get_serializer(active_tipos, many=True)
        return Response(serializer.data)

    def create(self, request, *args, **kwargs):
        # Puedes agregar validaciones adicionales si es necesario
        return super().create(request, *args, **kwargs)

    def update(self, request, *args, **kwargs):
        # Agregar lógica adicional si se necesita
        return super().update(request, *args, **kwargs)

    def destroy(self, request, *args, **kwargs):
        # Aquí puedes agregar lógica antes de eliminar un objeto, si es necesario
        return super().destroy(request, *args, **kwargs)

# Opción 1: Usando TokenObtainPairView (recomendado para JWT)
class CustomTokenObtainPairView(TokenObtainPairView):
    def post(self, request, *args, **kwargs):
        # Obtener la respuesta de TokenObtainPairView
        response = super().post(request, *args, **kwargs)

        if response.status_code == status.HTTP_200_OK:
            # Obtener el usuario y agregarle un rol
            user = User.objects.get(username=request.data['username'])
            role = 'admin' if user.is_superuser else 'usuario_basico'  # Se asigna el rol según si el usuario es superuser

            # Incluir el rol en la respuesta
            response.data['username'] = user.username
            response.data['role'] = role  # Agregar el rol
        return response


class AsistenciaViewSet(viewsets.ModelViewSet):
    queryset = Asistencia.objects.select_related('empleado')
    serializer_class = AsistenciaSerializer
    parser_classes = [MultiPartParser, FormParser]

    def perform_destroy(self, instance):
        # Elimina el archivo si existe
        if instance.foto:
            default_storage.delete(instance.foto.path)
        super().perform_destroy(instance)

    def create(self, request, *args, **kwargs):
        cedula = request.data.get('cedula')
        if not cedula:
            return Response({"error": "La cédula es requerida"}, status=400)

        try:
            empleado = Empleado.objects.get(cedula=cedula)
        except Empleado.DoesNotExist:
            return Response({"error": "Empleado no encontrado"}, status=404)

        if 'foto' not in request.FILES:
            return Response({"error": "La foto es requerida"}, status=400)

        try:
            asistencia = Asistencia.objects.create(
                empleado=empleado,
                foto=request.FILES['foto']
            )
            return Response({
    "id": asistencia.id,
    "empleado": empleado.cedula,
    "nombre_empleado": f"{empleado.nombre} {empleado.apellido}",
    "fecha": asistencia.fecha,
    "hora": asistencia.hora,
    "foto": request.build_absolute_uri(asistencia.foto.url)
}, status=201)
        except Exception as e:
            return Response({"error": str(e)}, status=500)
        
class EmpleadoViewSet(viewsets.ModelViewSet):
    queryset = Empleado.objects.all()
    serializer_class = EmpleadoSerializer
    permission_classes = [AllowAny]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        try:
            self.perform_create(serializer)
            headers = self.get_success_headers(serializer.data)
            return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)
        except IntegrityError as e:
            if 'PRIMARY' in str(e):
                return Response(
                    {'error': 'Esta cédula ya está registrada en el sistema'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            return Response(
                {'error': 'Error al registrar el empleado'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    def perform_create(self, serializer):
        """Guarda el empleado generando automáticamente el código"""
        try:
            serializer.save()
        except IntegrityError:
            # Recupera el último código si hay colisión
            last_code = Empleado.objects.all().order_by('-Codigo_empleado').first()
            if last_code:
                new_code = last_code.Codigo_empleado + 1
                serializer.validated_data['Codigo_empleado'] = new_code
                serializer.save()

    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()

    # Copiar request.data para que sea mutable
        data = request.data.copy()
    
    # Forzamos a que la cédula no se pueda modificar
        data['cedula'] = instance.cedula
    
        serializer = self.get_serializer(instance, data=data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
    
        return Response(serializer.data)

    def partial_update(self, request, *args, **kwargs):
        """
        Maneja actualización parcial (PATCH)
        """
        return self.update(request, *args, **kwargs)
class PagoViewSet(viewsets.ModelViewSet):
    queryset = Pago.objects.select_related('empleado', 'empleado__cargo').prefetch_related('bonos').all()
    serializer_class = PagoSerializer
    permission_classes = [AllowAny]  # Cambia a [IsAuthenticated] si necesitas autenticación

    def get_queryset(self):
        queryset = super().get_queryset()
        
        # Filtro para usuarios no superuser
        if not self.request.user.is_anonymous and not self.request.user.is_superuser:
            try:
                empleado = Empleado.objects.get(user=self.request.user)
                queryset = queryset.filter(empleado=empleado)
            except Empleado.DoesNotExist:
                return Pago.objects.none()
                
        return queryset.order_by('-fecha_pago')

    def perform_create(self, serializer):
        empleado = serializer.validated_data.get('empleado')
        
        # Validar que el empleado tenga cargo asignado
        if not empleado.cargo:
            raise serializers.ValidationError(
                {"empleado": "El empleado no tiene un cargo asignado"}
            )
        
        # Establecer sueldo_base automáticamente del cargo
        serializer.validated_data['sueldo_base'] = empleado.cargo.sueldo
        
        # Calcular total inicial (sin bonos aún)
        deducciones = serializer.validated_data.get('deducciones', 0)
        total_bonos = sum(bono.valor for bono in serializer.validated_data.get('bonos', []))
        serializer.validated_data['pago_total'] = empleado.cargo.sueldo + total_bonos - deducciones
        
        # Guardar el pago
        serializer.save()

    def perform_update(self, serializer):
        empleado = serializer.validated_data.get('empleado', serializer.instance.empleado)
        
        # Si cambia el empleado, validar que tenga cargo
        if 'empleado' in serializer.validated_data and not empleado.cargo:
            raise serializers.ValidationError(
                {"empleado": "El empleado no tiene un cargo asignado"}
            )
        
        # Si cambia el empleado, actualizar sueldo_base
        if 'empleado' in serializer.validated_data:
            serializer.validated_data['sueldo_base'] = empleado.cargo.sueldo
        
        # Recalcular total si hay cambios en bonos, deducciones o empleado
        if any(field in serializer.validated_data for field in ['bonos', 'deducciones', 'empleado']):
            bonos = serializer.validated_data.get('bonos', serializer.instance.bonos.all())
            total_bonos = sum(bono.valor for bono in bonos)
            deducciones = serializer.validated_data.get('deducciones', serializer.instance.deducciones)
            sueldo_base = serializer.validated_data.get('sueldo_base', serializer.instance.sueldo_base)
            serializer.validated_data['pago_total'] = sueldo_base + total_bonos - deducciones
        
        # Guardar los cambios
        serializer.save()

    @action(detail=True, methods=['post'])
    def asignar_bonos(self, request, pk=None):
        pago = self.get_object()
        bono_ids = request.data.get('bonos', [])
        
        try:
            bonos = Bono.objects.filter(id__in=bono_ids)
            pago.bonos.set(bonos)
            
            # Recalcular el total
            total_bonos = sum(bono.valor for bono in bonos)
            pago.pago_total = pago.sueldo_base + total_bonos - pago.deducciones
            pago.save()
            
            return Response(self.get_serializer(pago).data)
        except Exception as e:
            return Response(
                {"error": str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )

    @action(detail=True, methods=['post'])
    def agregar_bono(self, request, pk=None):
        pago = self.get_object()
        bono_id = request.data.get('bono_id')
        
        if not bono_id:
            return Response(
                {"error": "Se requiere el ID del bono"},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            bono = Bono.objects.get(id=bono_id)
            pago.bonos.add(bono)
            
            # Recalcular el total
            pago.pago_total = pago.sueldo_base + sum(bono.valor for bono in pago.bonos.all()) - pago.deducciones
            pago.save()
            
            return Response(self.get_serializer(pago).data)
        except Bono.DoesNotExist:
            return Response(
                {"error": "Bono no encontrado"},
                status=status.HTTP_404_NOT_FOUND
            )
        except Exception as e:
            return Response(
                {"error": str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )

    @action(detail=True, methods=['post'])
    def remover_bono(self, request, pk=None):
        pago = self.get_object()
        bono_id = request.data.get('bono_id')
        
        if not bono_id:
            return Response(
                {"error": "Se requiere el ID del bono"},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            bono = Bono.objects.get(id=bono_id)
            pago.bonos.remove(bono)
            
            # Recalcular el total
            pago.pago_total = pago.sueldo_base + sum(bono.valor for bono in pago.bonos.all()) - pago.deducciones
            pago.save()
            
            return Response(self.get_serializer(pago).data)
        except Bono.DoesNotExist:
            return Response(
                {"error": "Bono no encontrado"},
                status=status.HTTP_404_NOT_FOUND
            )
        except Exception as e:
            return Response(
                {"error": str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )
        
class ReposoViewSet(viewsets.ModelViewSet):
    serializer_class = ReposoSerializer
    permission_classes = [AllowAny]  # O cambia a [IsAuthenticated] si prefieres

    def get_queryset(self):
        queryset = Reposo.objects.all().order_by('-fecha_inicio')
        
        # Si el usuario está autenticado y no es superuser
        if not self.request.user.is_anonymous and not self.request.user.is_superuser:
            try:
                # Obtener el empleado asociado al usuario
                empleado = Empleado.objects.get(user=self.request.user)
                queryset = queryset.filter(empleado=empleado)
            except Empleado.DoesNotExist:
                return Reposo.objects.none()
                
        return queryset

    def perform_create(self, serializer):
        # Si el usuario no es superuser, asocia automáticamente su empleado
        if not self.request.user.is_superuser and not self.request.user.is_anonymous:
            try:
                empleado = Empleado.objects.get(user=self.request.user)
                serializer.save(empleado=empleado)
            except Empleado.DoesNotExist:
                raise ValidationError(
                    {"error": "No existe un empleado asociado a este usuario"}
                )
        else:
            # Para superusers o usuarios anónimos (dependiendo de tus necesidades)
            serializer.save()

class PermisoViewSet(viewsets.ModelViewSet):
    serializer_class = PermisoSerializer
    permission_classes = [AllowAny]  # O cambia a [IsAuthenticated] si prefieres

    def get_queryset(self):
        queryset = Permiso.objects.all().order_by('-fecha_inicio')
        
        # Si el usuario está autenticado y no es superuser
        if not self.request.user.is_anonymous and not self.request.user.is_superuser:
            try:
                # Obtener el empleado asociado al usuario
                empleado = Empleado.objects.get(user=self.request.user)
                queryset = queryset.filter(empleado=empleado)
            except Empleado.DoesNotExist:
                return Permiso.objects.none()
                
        return queryset

    def perform_create(self, serializer):
        # Si el usuario no es superuser, asocia automáticamente su empleado
        if not self.request.user.is_superuser and not self.request.user.is_anonymous:
            try:
                empleado = Empleado.objects.get(user=self.request.user)
                serializer.save(empleado=empleado)
            except Empleado.DoesNotExist:
                raise ValidationError(
                    {"error": "No existe un empleado asociado a este usuario"}
                )
        else:
            # Para superusers o usuarios anónimos (dependiendo de tus necesidades)
            serializer.save()
