from rest_framework import serializers
from django.core.validators import MinLengthValidator, RegexValidator  # Importar desde Django
from .models import Asistencia, Reposo, Empleado, Pago, TipoReposo, Permiso, TipoPermiso, PerfilUsuario, Cargo, Bono
from django.utils import timezone
from rest_framework.response import Response
from urllib.parse import urljoin
from django.conf import settings
from datetime import date
from django.contrib.auth.models import User
from rest_framework.views import APIView
from datetime import datetime



class UserPermisosSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'is_superuser']
        extra_kwargs = {
            'is_superuser': {'required': False}
        }

class BonoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Bono
        fields = ['id', 'nombre', 'valor', 'descripcion', 'creado_en']
        read_only_fields = ['id', 'creado_en']

class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, required=True)

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'password']

    def create(self, validated_data):
        user = User(
            username=validated_data['username'],
            email=validated_data.get('email', '')
        )
        user.set_password(validated_data['password'])
        user.save()
        return user

class PerfilUsuarioSerializer(serializers.ModelSerializer):
    color_favorito = serializers.CharField(required=True, allow_blank=False)
    comida_favorita = serializers.CharField(required=True, allow_blank=False)
    animal_favorito = serializers.CharField(required=True, allow_blank=False)

    class Meta:
        model = PerfilUsuario
        fields = ['color_favorito', 'comida_favorita', 'animal_favorito']
        extra_kwargs = {
            'color_favorito': {'required': False, 'allow_blank': True},
            'comida_favorita': {'required': False, 'allow_blank': True},
            'animal_favorito': {'required': False, 'allow_blank': True}
        }
class UserBasicSerializer(serializers.ModelSerializer):
    perfil = PerfilUsuarioSerializer(required=True)
    password = serializers.CharField(write_only=True, required=False, allow_blank=True)

    class Meta:
        model = User
        fields = ['id', 'username', 'password', 'email', 'is_superuser', 'perfil']
        extra_kwargs = {
            'is_superuser': {'required': False}  # permite editar
        }

    def create(self, validated_data):
       perfil_data = validated_data.pop('perfil', None)
       password = validated_data.pop('password')

       print(">>> PERFIL RECIBIDO:", perfil_data)

       user = User(**validated_data)
       user.set_password(password)
       user.save()

       if perfil_data:
        PerfilUsuario.objects.create(user=user, **perfil_data)

       return user

    def update(self, instance, validated_data):
        # Se extrae el perfil y la contraseña si viene
        perfil_data = validated_data.pop('perfil', None)
        password = validated_data.pop('password', None)

        # Actualizar campos del usuario
        for attr, value in validated_data.items():
            setattr(instance, attr, value)

        # Si hay contraseña, se actualiza correctamente
        if password:
            instance.set_password(password)

        instance.save()

        # Actualizar perfil si viene
        if perfil_data:
            perfil = instance.perfil
            for attr, value in perfil_data.items():
                setattr(perfil, attr, value)
            perfil.save()

        return instance

class EditarUsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'email', 'first_name', 'last_name']


class CargoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cargo
        fields = ['id', 'nombre', 'sueldo', 'descripcion']

class AsistenciaSerializer(serializers.ModelSerializer):
    cedula = serializers.CharField(
        write_only=True,
        required=True,
        validators=[MinLengthValidator(5), RegexValidator(regex='^[0-9]+$')]
    )
    nombre_empleado = serializers.CharField(source='empleado.nombre_completo', read_only=True)
    empleado = serializers.PrimaryKeyRelatedField(read_only=True)
    foto_url = serializers.CharField(source='foto.url', read_only=True)

    class Meta:
        model = Asistencia
        fields = ['id', 'cedula', 'empleado', 'nombre_empleado', 'fecha', 'hora', 'foto', 'foto_url']
        read_only_fields = ['id', 'fecha', 'hora', 'empleado']

    def get_foto_url(self, obj):
        # Verifica si existe la foto, y devuelve la URL completa
        if obj.foto:
            return urljoin(settings.MEDIA_URL, obj.foto.url)  # Asegura que la URL sea completa
        return None  

    def validate(self, data):
        # Obtener la cédula y la fecha actual
        cedula = data.get('cedula')
        fecha_actual = date.today()

        # Verificar si ya existe una asistencia registrada para este empleado en el día de hoy
        if Asistencia.objects.filter(empleado__cedula=cedula, fecha=fecha_actual).exists():
            raise serializers.ValidationError("El empleado ya tiene una asistencia registrada para hoy.")

        return data  

    def create(self, validated_data):
        cedula = validated_data.pop('cedula')
        try:
            empleado = Empleado.objects.get(cedula=cedula)
        except Empleado.DoesNotExist:
            raise serializers.ValidationError({"cedula": "Empleado no encontrado."})
        return Asistencia.objects.create(empleado=empleado, **validated_data)


class EmpleadoSerializer(serializers.ModelSerializer):
    cargo = CargoSerializer(read_only=True)
    cargo_id = serializers.PrimaryKeyRelatedField(
        queryset=Cargo.objects.all(), source='cargo', write_only=True
    )
    sexo_display = serializers.CharField(source='get_sexo_display', read_only=True)
    foto = serializers.ImageField(required=False, allow_null=True)


    class Meta:
        model = Empleado
        fields = '__all__'
        extra_kwargs = {
            'Codigo_empleado': {'read_only': True},
            'cedula': {
                'validators': [
                    MinLengthValidator(6, message="La cédula debe tener al menos 6 dígitos"),
                    RegexValidator(
                        regex='^[0-9]+$',
                        message="La cédula solo debe contener números"
                    )
                ]
            }
        }
        
        
def validate_cedula(self, value):
    instance = getattr(self, 'instance', None)

    if instance and str(instance.cedula) == str(value):
        return value
        
    if Empleado.objects.filter(cedula=value).exists():
        raise serializers.ValidationError("Esta cédula ya está registrada")
    return value

def update(self, instance, validated_data):
        # Extraemos la foto si existe
        foto = validated_data.pop('foto', None)
        
        # Actualizamos otros campos
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        
        # Si se envió foto, actualizamos
        if foto is not None:
            instance.foto = foto
        
        instance.save()
        return instance

class TipoReposoSerializer(serializers.ModelSerializer):
    class Meta:
        model = TipoReposo
        fields = '__all__'
        extra_kwargs = {
            'id': {'read_only': True}
        }

class ReposoSerializer(serializers.ModelSerializer):
    empleado_nombre = serializers.SerializerMethodField()
    tipo_reposo_nombre = serializers.CharField(source='tipo_reposo.nombre', read_only=True)

    class Meta:
        model = Reposo
        fields = '__all__'
        extra_kwargs = {
            'fecha_registro': {'read_only': True}
        }   

    def get_empleado_nombre(self, obj):
        return f"{obj.empleado.nombre} {obj.empleado.apellido}" if obj.empleado else None

    def validate(self, data):
        if not self.context['request'].user.is_superuser and 'empleado' not in data:
            raise serializers.ValidationError("Se requiere un empleado para este registro")
        return data
    
class TipoPermisoSerializer(serializers.ModelSerializer):
    class Meta:
        model = TipoPermiso
        fields = ['id', 'nombre', 'duracion_dias_fija', 'descripcion']
        extra_kwargs = {
            'id': {'read_only': True}
        }

class PermisoSerializer(serializers.ModelSerializer):
    empleado_nombre = serializers.SerializerMethodField()
    tipo_permiso_nombre = serializers.CharField(source='tipo_permiso.nombre', read_only=True)

    class Meta:
        model = Permiso
        fields = [
            'id', 'empleado', 'empleado_nombre',
            'tipo_permiso', 'tipo_permiso_nombre',
            'fecha_inicio', 'fecha_fin', 'duracion',
            'descripcion', 'fecha_registro'
        ]
        extra_kwargs = {
            'empleado': {'required': False},
            'fecha_registro': {'read_only': True}
        }   

    def get_empleado_nombre(self, obj):
        return f"{obj.empleado.nombre} {obj.empleado.apellido}" if obj.empleado else None

    def validate(self, data):
        if not self.context['request'].user.is_superuser and 'empleado' not in data:
            raise serializers.ValidationError("Se requiere un empleado para este registro")
        return data

class PagoSerializer(serializers.ModelSerializer):
    empleado_nombre = serializers.SerializerMethodField()
    empleado_cedula = serializers.SerializerMethodField()
    cargo_nombre = serializers.CharField(source='empleado.cargo.nombre', read_only=True)
    sueldo_cargo = serializers.DecimalField(
        source='empleado.cargo.sueldo', 
        max_digits=10, 
        decimal_places=2, 
        read_only=True
    )
    
    # Campos de fecha con validación explícita
    fecha_inicial = serializers.DateField(required=True)
    fecha_final = serializers.DateField(required=True)
    fecha_pago = serializers.SerializerMethodField()

    bonos = serializers.PrimaryKeyRelatedField(
        queryset=Bono.objects.all(),
        many=True,
        required=False
    )


    class Meta:
        model = Pago
        fields = [
            'id', 'empleado', 'empleado_nombre', 'empleado_cedula', 'cargo_nombre', 'sueldo_cargo',
            'fecha_inicial', 'fecha_final', 'fecha_pago', 'sueldo_base',
            'bonos', 'deducciones', 'pago_total'
        ]
        read_only_fields = ['sueldo_base', 'pago_total', 'fecha_pago']

    def get_fecha_pago(self, obj):
        return obj.fecha_pago.date() if hasattr(obj.fecha_pago, 'date') else obj.fecha_pago

    def get_empleado_nombre(self, obj):
        return f"{obj.empleado.nombre} {obj.empleado.apellido}"

    def get_empleado_cedula(self, obj):
        return obj.empleado.cedula

    def validate(self, data):
        # Validación de campos requeridos
        if 'fecha_inicial' not in data:
            raise serializers.ValidationError({
                "fecha_inicial": "Este campo es requerido"
            })
        
        if 'fecha_final' not in data:
            raise serializers.ValidationError({
                "fecha_final": "Este campo es requerido"
            })
        
        # Validación de relación entre fechas
        if data['fecha_inicial'] > data['fecha_final']:
            raise serializers.ValidationError({
                "fecha_final": "Debe ser posterior a la fecha inicial"
            })
        
        # Validación de cargo del empleado
        empleado = data.get('empleado') or (self.instance.empleado if self.instance else None)
        if empleado and not empleado.cargo:
            raise serializers.ValidationError({
                "empleado": "El empleado no tiene un cargo asignado"
            })
            
        return data

    
    def create(self, validated_data):
        # Extraer bonos si existen
        bonos = validated_data.pop('bonos', [])
        
        # Crear el pago
        empleado = validated_data['empleado']
        validated_data['sueldo_base'] = empleado.cargo.sueldo
        
        # Calcular total inicial
        total_bonos = sum(bono.valor for bono in bonos)
        validated_data['pago_total'] = empleado.cargo.sueldo + total_bonos - validated_data.get('deducciones', 0)
        
        pago = Pago.objects.create(**validated_data)
        
        # Asignar bonos
        pago.bonos.set(bonos)
        
        return pago

    def update(self, instance, validated_data):
        # Manejar bonos si se proporcionan
        bonos = validated_data.pop('bonos', None)
        
        # Actualizar otros campos
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        
        # Actualizar bonos si se enviaron
        if bonos is not None:
            instance.bonos.set(bonos)
        
        # Recalcular total
        total_bonos = sum(bono.valor for bono in instance.bonos.all())
        instance.pago_total = instance.sueldo_base + total_bonos - instance.deducciones
        
        instance.save()
        return instance