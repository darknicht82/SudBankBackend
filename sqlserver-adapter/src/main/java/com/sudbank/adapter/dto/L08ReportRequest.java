package com.sudbank.adapter.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class L08ReportRequest {
    
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private String tipoReporte;
    private String formato;
    private List<String> filtros;
    private String codigoInstitucion;
    private String usuarioGenerador;
    private String observaciones;
} 