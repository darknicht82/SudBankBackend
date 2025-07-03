package com.sudbank.adapter.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class L08ReportResponse {
    
    private String idReporte;
    private String nombreReporte;
    private String estado;
    private LocalDateTime fechaGeneracion;
    private String usuarioGenerador;
    private String archivoGenerado;
    private String rutaArchivo;
    private Long registrosProcesados;
    private Long registrosValidos;
    private Long registrosConErrores;
    private List<String> errores;
    private List<String> advertencias;
    private String observaciones;
    private String formatoArchivo;
    private Long tamanoArchivo;
    private String checksum;
} 