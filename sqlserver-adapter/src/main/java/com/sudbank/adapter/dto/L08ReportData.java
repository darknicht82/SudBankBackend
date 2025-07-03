package com.sudbank.adapter.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class L08ReportData {
    private Long id; // PK técnica
    private Integer codigoLiquidez;           // numeric(6,0)
    private String tipoIdentificacion;        // char(1)
    private String identificacionEntidad;     // numeric(13,0) -> String para ceros a la izquierda
    private Integer tipoInstrumento;          // numeric(2,0)
    private Integer calificacionEntidad;      // numeric(2,0)
    private Integer calificadoraRiesgo;       // numeric(2,0)
    private BigDecimal valorLunes;            // decimal(16,8)
    private BigDecimal valorMartes;           // decimal(16,8)
    private BigDecimal valorMiercoles;        // decimal(16,8)
    private BigDecimal valorJueves;           // decimal(16,8)
    private BigDecimal valorViernes;          // decimal(16,8)
    private LocalDate fechaReporte;           // date
    private String entidadCodigo;             // char(4)
}
