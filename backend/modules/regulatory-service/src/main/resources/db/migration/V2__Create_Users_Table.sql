-- =====================================================
-- Migración V2: Crear Tabla de Usuarios
-- Fecha: 2024-12-19
-- Descripción: Crear tabla de usuarios para autenticación
-- =====================================================

-- Crear tabla de usuarios
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[auth].[users]') AND type in (N'U'))
BEGIN
    CREATE TABLE [auth].[users] (
        [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
        [username] VARCHAR(50) NOT NULL UNIQUE,
        [email] VARCHAR(100) NOT NULL UNIQUE,
        [password_hash] VARCHAR(255) NOT NULL,
        [role] VARCHAR(20) NOT NULL DEFAULT 'USER',
        [is_active] BIT DEFAULT 1,
        [fecha_creacion] DATETIME2 DEFAULT GETDATE(),
        [fecha_modificacion] DATETIME2 DEFAULT GETDATE()
    );
    
    -- Crear índices para optimizar consultas
    CREATE INDEX [IX_users_username] ON [auth].[users] ([username]);
    CREATE INDEX [IX_users_email] ON [auth].[users] ([email]);
    CREATE INDEX [IX_users_active] ON [auth].[users] ([is_active]);
    
    PRINT 'Tabla auth.users creada exitosamente';
END
ELSE
BEGIN
    PRINT 'Tabla auth.users ya existe';
END

-- Insertar usuario administrador por defecto (password: admin123)
IF NOT EXISTS (SELECT * FROM [auth].[users] WHERE username = 'admin')
BEGIN
    INSERT INTO [auth].[users] ([username], [email], [password_hash], [role], [is_active])
    VALUES ('admin', 'admin@sudbank.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'ADMIN', 1);
    PRINT 'Usuario administrador creado exitosamente';
END
ELSE
BEGIN
    PRINT 'Usuario administrador ya existe';
END

PRINT 'Migración V2 completada exitosamente'; 