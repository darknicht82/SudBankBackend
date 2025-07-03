package com.sudbank.regulatory.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class L08DTO {
    private Long id;
    private String codigoLiquidez;
    private String tipoIdentificacion;
    private String identificacionEmisor;
    private String tipoInstrumento;
    private BigDecimal valorLunes;
    private BigDecimal valorMartes;
    private BigDecimal valorMiercoles;
    private BigDecimal valorJueves;
    private BigDecimal valorViernes;
    private LocalDate fechaReporte;
    private String entidadCodigo;
} 