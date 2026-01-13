<!-- Android Manifest Configuration -->
<!-- Agrega estas líneas dentro de la sección <manifest> -->

<!-- Permisos -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

<!-- Para Android 11+ es recomendado usar MANAGE_EXTERNAL_STORAGE -->
<!-- <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" /> -->

<!-- Configuración de la aplicación -->
<application>
    <!-- ...otras configuraciones... -->

    <!-- Especificar que la aplicación es compatible con gestos de desplazamiento -->
    <meta-data
        android:name="com.google.android.gms.version"
        android:value="@integer/google_play_services_version" />
</application>
