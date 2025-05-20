from django.db import models
from django.utils import timezone
from django.core.validators import RegexValidator, MinLengthValidator, FileExtensionValidator
from django.contrib.auth.models import User
from django.core.exceptions import ValidationError
from datetime import timedelta

class PerfilUsuario(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='perfil')  # Relación uno a uno
    color_favorito = models.CharField(max_length=30)
    comida_favorita = models.CharField(max_length=50)
    animal_favorito = models.CharField(max_length=30)

    def __str__(self):
        return f'Perfil de {self.user.username}'

class Cargo(models.Model):
    nombre = models.CharField(max_length=100, unique=True)
    descripcion = models.TextField(blank=True, null=True)
    sueldo = models.DecimalField(max_digits=20, decimal_places=2, default=0.00)

    def __str__(self):
        return self.nombre

class Empleado(models.Model):
    SEXO_CHOICES = [
        ('M', 'Masculino'),
        ('F', 'Femenino'),
    ]
    cedula = models.CharField(
        max_length=12,
        primary_key=True,
        validators=[
            MinLengthValidator(6),
            RegexValidator(regex='^[0-9]+$')
        ]
    )
    Codigo_empleado = models.IntegerField(unique=True, editable=False, null=True, blank=True, db_column='Codigo_empleado')
    nombre = models.CharField(max_length=100)
    apellido = models.CharField(max_length=100)
    direccion = models.CharField(max_length=255)
    telefono = models.CharField(max_length=15)
    sexo = models.CharField(max_length=1, choices=SEXO_CHOICES, default='M')
    cargo = models.ForeignKey(Cargo, on_delete=models.SET_NULL, null=True, blank=True)
    foto = models.ImageField(upload_to='empleados/fotos/', null=True, blank=True, validators=[FileExtensionValidator(allowed_extensions=['jpg', 'jpeg', 'png'])] ) 
    user = models.OneToOneField(User, on_delete=models.CASCADE, null=True, blank=True)

    @property
    def nombre_completo(self):
        return f"{self.nombre} {self.apellido}"

    def save(self, *args, **kwargs):
        if not self.Codigo_empleado:
            last_code = Empleado.objects.all().order_by('-Codigo_empleado').first()
            self.Codigo_empleado = (last_code.Codigo_empleado + 1) if last_code else 1
        super().save(*args, **kwargs)

    class Meta:
        db_table = 'api_empleado'
        verbose_name_plural = 'Empleados'

    def __str__(self):
        return f"{self.Codigo_empleado} - {self.nombre}"


class Bono(models.Model):
    nombre = models.CharField(max_length=100)
    valor = models.DecimalField(max_digits=10, decimal_places=2)
    descripcion = models.TextField()
    creado_en = models.DateTimeField(auto_now_add=True)

    def _str_(self):
        return self.nombre

class Asistencia(models.Model):
    empleado = models.ForeignKey(
        'Empleado', 
        on_delete=models.CASCADE,  # Crucial para mantener consistencia
        to_field='cedula'
    )
    fecha = models.DateField(auto_now_add=True)  # Automático
    hora = models.TimeField(auto_now_add=True)   # Automático
    foto = models.ImageField(
        upload_to='asistencias/%Y/%m/%d/',  # Organiza por año/mes/día
        validators=[FileExtensionValidator(allowed_extensions=['jpg', 'jpeg', 'png'])]
    )  # Mejor que CharField

    class Meta:
        db_table = 'api_asistencia'
        unique_together = ('empleado', 'fecha')
        
    def __str__(self):
        return f"Asistencia {self.id} - {self.empleado.nombre}"
    
class TipoReposo(models.Model):
    nombre = models.CharField(max_length=50, unique=True)
    descripcion = models.TextField(blank=True, null=True)
    duracion_dias_fija = models.IntegerField()  

    def __str__(self):
        return self.nombre
    
class Reposo(models.Model):
    empleado = models.ForeignKey(
        Empleado, 
        on_delete=models.CASCADE,
        null=True,
        blank=True
    )
    tipo_reposo = models.ForeignKey(TipoReposo, on_delete=models.CASCADE)
    fecha_inicio = models.DateField()
    fecha_fin = models.DateField()
    duracion_dias = models.IntegerField()
    descripcion = models.TextField(blank=True, null=True)
    fecha_registro = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"{self.empleado.nombre} {self.empleado.apellido} - {self.tipo_reposo.nombre} ({self.fecha_inicio} al {self.fecha_fin})"

    def clean(self):
        if self.fecha_inicio > self.fecha_fin:
            raise ValidationError("La fecha de inicio no puede ser posterior a la fecha de fin.")

        nombre_tipo = self.tipo_reposo.nombre.upper()
        if nombre_tipo in ['ENFERMEDAD', 'ACCIDENTE']:
            expected_duration = (self.fecha_fin - self.fecha_inicio).days + 1
            if self.duracion_dias is not None and self.duracion_dias != expected_duration:
                raise ValidationError(f"La duración en días debe coincidir con las fechas: {expected_duration} días.")

    def save(self, *args, **kwargs):
        nombre_tipo = self.tipo_reposo.nombre.upper()

        if nombre_tipo == 'MATERNIDAD':
            self.duracion_dias = 182
            self.fecha_fin = self.fecha_inicio + timedelta(days=181)
        elif nombre_tipo == 'PATERNIDAD':
            self.duracion_dias = 14
            self.fecha_fin = self.fecha_inicio + timedelta(days=13)
        elif nombre_tipo == 'VACACIONES':
            self.duracion_dias = 15
            self.fecha_fin = self.fecha_inicio + timedelta(days=14)
        elif nombre_tipo in ['ENFERMEDAD', 'ACCIDENTE']:
            if self.tipo_reposo and self.fecha_inicio:
             self.duracion_dias = self.tipo_reposo.duracion_dias_fija
            self.fecha_fin = self.fecha_inicio + timedelta(days=self.duracion_dias)

        self.clean()
        super().save(*args, **kwargs)

class TipoPermiso(models.Model):
    nombre = models.CharField(max_length=50, unique=True)
    descripcion = models.TextField(blank=True, null=True)
    duracion_dias_fija = models.IntegerField()  

    def __str__(self):
        return self.nombre
    
class Permiso(models.Model):
    empleado = models.ForeignKey(
        Empleado, 
        on_delete=models.CASCADE,
        null=True,
        blank=True
    )
    tipo_permiso = models.ForeignKey(
        TipoPermiso,
        on_delete=models.PROTECT,
        related_name='permisos'
    )
    fecha_inicio = models.DateField()
    fecha_fin = models.DateField()
    duracion = models.IntegerField()
    descripcion = models.TextField(blank=True, null=True)
    fecha_registro = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"{self.empleado.nombre} {self.empleado.apellido} - {self.tipo_permiso.nombre} ({self.fecha_inicio} al {self.fecha_fin})"

    def clean(self):
        if self.fecha_inicio > self.fecha_fin:
            raise ValidationError("La fecha de inicio no puede ser posterior a la fecha de fin.")

        nombre_tipo = self.tipo_permiso.nombre.upper()
        if nombre_tipo in ['MIGRAÑA', 'CONSULTA MEDICA']:
            expected_duration = (self.fecha_fin - self.fecha_inicio).days + 1
            if self.duracion is not None and self.duracion != expected_duration:
                raise ValidationError(f"La duración en días debe coincidir con las fechas: {expected_duration} días.")

    def save(self, *args, **kwargs):
        nombre_tipo = self.tipo_permiso.nombre.upper()

        if nombre_tipo == 'FALLECIMIENTO FAMILIAR':
            self.duracion = 182
            self.fecha_fin = self.fecha_inicio + timedelta(days=181)
        elif nombre_tipo == 'RENOVACION DE DOCUMENTO':
            self.duracion = 14
            self.fecha_fin = self.fecha_inicio + timedelta(days=13)
        elif nombre_tipo == 'EMERGENCIA CLINICA':
            self.duracion = 15
            self.fecha_fin = self.fecha_inicio + timedelta(days=14)
        elif nombre_tipo in ['MIGRAÑA', 'CONSULTA MEDICA']:
            if self.tipo_permiso and self.fecha_inicio:
             self.duracion = self.tipo_permiso.duracion_dias_fija
            self.fecha_fin = self.fecha_inicio + timedelta(days=self.duracion)

        self.clean()
        super().save(*args, **kwargs)

class Pago(models.Model):
    empleado = models.ForeignKey(Empleado, on_delete=models.CASCADE, db_column='empleado_id')
    fecha_inicial = models.DateField()
    fecha_final = models.DateField()
    fecha_pago = models.DateField(auto_now_add=True)
    sueldo_base = models.DecimalField(max_digits=10, decimal_places=2, editable=False)
    bonos = models.ManyToManyField('Bono', blank=True)
    deducciones = models.DecimalField(max_digits=10, decimal_places=2, default=0.0)
    pago_total = models.DecimalField(max_digits=10, decimal_places=2)

def calcular_total(self):
        total_bonos = sum(bono.valor for bono in self.bonos.all())
        return self.sueldo_base + total_bonos - self.deducciones

def save(self, *args, **kwargs):
        self.pago_total = self.calcular_total()
        super().save(*args, **kwargs)

def __str__(self):
        return f"Pago #{self.id} - {self.empleado.nombre}"