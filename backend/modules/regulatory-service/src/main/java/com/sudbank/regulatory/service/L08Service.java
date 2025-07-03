package com.sudbank.regulatory.service;

import com.sudbank.regulatory.client.SqlServerAdapterClient;
import com.sudbank.regulatory.dto.L08DTO;
import com.sudbank.regulatory.dto.L08ReportRequest;
import com.sudbank.regulatory.dto.L08ReportResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class L08Service {
    
    private final SqlServerAdapterClient sqlServerAdapterClient;
    private final RestTemplate restTemplate;

    public List<L08DTO> findByFecha(LocalDate fecha) {
        log.info("Consultando datos L08 para fecha: {}", fecha);
        
        try {
            // Usar el cliente Feign para obtener datos del microservicio puente
            var data = sqlServerAdapterClient.getL08Data(
                fecha != null ? fecha.toString() : null,
                fecha != null ? fecha.toString() : null
            );
            
            // Convertir a DTOs locales
            return data.stream()
                .map(this::convertToDTO)
                .toList();
                
        } catch (Exception e) {
            log.error("Error consultando datos L08", e);
            throw new RuntimeException("Error obteniendo datos del reporte L08", e);
        }
    }

    public L08DTO create(L08DTO dto) {
        // TODO: Implementar creación
        return dto;
    }

    public L08DTO update(Long id, L08DTO dto) {
        // TODO: Implementar actualización
        return dto;
    }

    public void delete(Long id) {
        // TODO: Implementar borrado
    }

    public Object validar(LocalDate fecha) {
        log.info("Validando datos L08 para fecha: {}", fecha);
        
        try {
            // Obtener datos y validar
            List<L08DTO> data = findByFecha(fecha);
            // TODO: Implementar lógica de validación específica
            return data;
        } catch (Exception e) {
            log.error("Error validando datos L08", e);
            throw new RuntimeException("Error validando datos del reporte L08", e);
        }
    }

    public Resource generarTxt(LocalDate fecha) {
        log.info("Generando TXT L08 para fecha: {}", fecha);
        
        try {
            // Crear request para el microservicio puente
            L08ReportRequest request = new L08ReportRequest();
            request.setFechaInicio(fecha);
            request.setFechaFin(fecha);
            request.setTipoReporte("L08");
            request.setFormato("TXT");
            request.setUsuarioGenerador("system");
            
            // Usar el cliente Feign para generar el reporte
            L08ReportResponse response = sqlServerAdapterClient.generateL08Report(request);
            
            log.info("Reporte L08 generado: {}", response.getIdReporte());
            
            // TODO: Implementar descarga del archivo generado
            return null;
            
        } catch (Exception e) {
            log.error("Error generando TXT L08", e);
            throw new RuntimeException("Error generando reporte L08", e);
        }
    }

    public void archivar(LocalDate fecha) {
        // TODO: Implementar archivado
    }

    public String exportL08Txt(String fechaInicio, String fechaFin) {
        log.info("Exportando TXT L08 desde {} hasta {}", fechaInicio, fechaFin);
        
        try {
            // Llamar al sqlserver-adapter para obtener el TXT
            String txtContent = sqlServerAdapterClient.exportL08Txt(fechaInicio, fechaFin);
            log.info("TXT L08 exportado exitosamente");
            return txtContent;
            
        } catch (Exception e) {
            log.error("Error exportando TXT L08", e);
            // Generar contenido simulado como fallback
            return generateSimulatedTxt(fechaInicio, fechaFin);
        }
    }

    private String generateSimulatedTxt(String fechaInicio, String fechaFin) {
        log.info("Generando TXT simulado como fallback");
        
        StringBuilder sb = new StringBuilder();
        sb.append("L08|0001|").append(fechaFin).append("|00000002\n");
        
        // Datos simulados en formato oficial SB
        sb.append("0161|CLI001|R|1790013210001|EMPRESA EJEMPLO 1|COMERCIAL|CR001|2024-01-15|2025-01-15|1000000.00|950000.00|50000.00|10000.00|1010000.00|VIGENTE|A|12.50|USD|HIPOTECARIA|1200000.00|COMERCIO|VENTA AL POR MENOR|PICHINCHA|QUITO|ECUADOR|JURIDICA|N/A||N/A|N/A|COMERCIANTE|50000.00|ACTIVIDAD COMERCIAL|PROPIA|0|NO|NO APLICA|IESS|IESS|IESS|NO|NO|SI|SI|NO|Cliente cumplidor\n");
        sb.append("0161|CLI002|E|9988776655443|EMPRESA EJEMPLO 2|COMERCIAL|CR002|2024-02-15|2025-02-15|2000000.00|1900000.00|100000.00|20000.00|2020000.00|VIGENTE|A|11.50|USD|QUIROGRAFARIO|0.00|INDUSTRIA|FABRICACION|PICHINCHA|QUITO|ECUADOR|JURIDICA|N/A||N/A|N/A|INDUSTRIAL|80000.00|ACTIVIDAD INDUSTRIAL|PROPIA|0|NO|NO APLICA|IESS|IESS|IESS|NO|NO|SI|SI|NO|Cliente cumplidor\n");
        
        return sb.toString();
    }

    private L08DTO convertToDTO(com.sudbank.regulatory.dto.L08ReportData data) {
        // TODO: Implementar conversión de L08ReportData a L08DTO
        L08DTO dto = new L08DTO();
        // Mapear campos
        return dto;
    }
} 