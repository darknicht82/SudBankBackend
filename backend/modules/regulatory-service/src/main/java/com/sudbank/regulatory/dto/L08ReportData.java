package com.sudbank.regulatory.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * DTO para los datos del reporte L08
 * Representa la estructura de datos que viene del SQL Server Adapter
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class L08ReportData {
    
    private Long id;
    private String codigoCliente;
    private String nombreCliente;
    private String tipoCredito;
    private BigDecimal montoCredito;
    private BigDecimal saldoCapital;
    private BigDecimal saldoIntereses;
    private BigDecimal saldoTotal;
    private LocalDate fechaVencimiento;
    private String estadoCredito;
    private String clasificacionRiesgo;
    private String tipoGarantia;
    private BigDecimal valorGarantia;
    private String sectorEconomico;
    private String tipoMoneda;
    private LocalDate fechaCreacion;
    private String usuarioCreacion;
    private LocalDate fechaModificacion;
    private String usuarioModificacion;
} 