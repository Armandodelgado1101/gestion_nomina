"""
URL configuration for ferreteria project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""

from django.contrib import admin
from django.conf import settings
from django.conf.urls.static import static
from django.urls import path, include
from rest_framework import routers
from api import views
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)
from api.views import (
    AsistenciaViewSet,
    EmpleadoViewSet,
    PagoViewSet,
    ReposoViewSet,
    CustomTokenObtainPairView,
    TipoReposoViewSet,
    TipoPermisoViewSet,
    PermisoViewSet,
    registro,
    CargoViewSet,
    UsuarioActualView,
    EditarUsuarioView,
    GestionPermisosView,
    usuario_actual,
    UsuarioViewSet,
    CambiarPasswordConPreguntas,
    BonoDetailView,
    BonoListCreateView
    
)

router = routers.DefaultRouter()
router.register(r'asistencias', AsistenciaViewSet, basename='asistencias')
router.register(r'reposos', ReposoViewSet, basename='reposos')
router.register(r'empleados', EmpleadoViewSet, basename='empleados')
router.register(r'pagos', PagoViewSet, basename='pagos')
router.register(r'tipos_reposo', TipoReposoViewSet, basename='tipos_reposo')
router.register(r'tipos_permiso', TipoPermisoViewSet, basename='tipos_permiso')
router.register(r'permisos', PermisoViewSet, basename='permisos')
router.register(r'cargos', CargoViewSet, basename='cargo')
router.register(r'usuarios', UsuarioViewSet)




urlpatterns = [
    # Admin
    path('admin/', admin.site.urls),
    
    # Autenticación
    path('api/auth/login/', CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('bonos/', BonoListCreateView.as_view(), name='bono-list-create'),
    path('bonos/<int:pk>/', BonoDetailView.as_view(), name='bono-detail'),
    path('api/auth/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/auth/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('api/auth/cambiar_password/', CambiarPasswordConPreguntas.as_view()),
    path('importar-db/', views.importar_bd),
    path('exportar-db/', views.exportar_bd),
    path('registro/', UsuarioViewSet.as_view({'post': 'create'})),
    path('api/usuario_actual/', UsuarioActualView.as_view(), name='usuario_actual'),
    path('api/editar-usuario/', EditarUsuarioView.as_view(), name='editar_usuario'),
    path('api/gestionar-permisos/', GestionPermisosView.as_view(), name='gestionar_permisos'),
    path('usuarios/<int:id>/', EditarUsuarioView.as_view(), name='editar_usuario'),
    path('api/usuarios/me/', views.usuario_actual),
    # API Endpoints
    path('api/', include(router.urls)),
    # Documentación (opcional)
    path('api/docs/', include('rest_framework.urls', namespace='rest_framework')),
] 
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)