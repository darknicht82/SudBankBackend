package com.sudbank.adapter.service;

import com.sudbank.adapter.dto.L08ReportData;
import com.sudbank.adapter.dto.L08ReportRequest;
import com.sudbank.adapter.dto.L08ReportResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class RegulatoryDataService {

    private final JdbcTemplate jdbcTemplate;

    public List<L08ReportData> getL08Data(String fechaInicio, String fechaFin) {
        log.info("Obteniendo datos L08 - Liquidez Estructural desde {} hasta {}", fechaInicio, fechaFin);
        
        String sql = "SELECT " +
            "  id, " +
            "  codigo_liquidez, " +
            "  tipo_identificacion, " +
            "  identificacion_entidad, " +
            "  tipo_instrumento, " +
            "  calificacion_entidad, " +
            "  calificadora_riesgo, " +
            "  valor_lunes, " +
            "  valor_martes, " +
            "  valor_miercoles, " +
            "  valor_jueves, " +
            "  valor_viernes, " +
            "  fecha_reporte, " +
            "  entidad_codigo " +
            "FROM liquidez_estructural " +
            "WHERE 1=1 ";
        
        List<Object> params = new ArrayList<>();
        
        if (fechaInicio != null && !fechaInicio.isEmpty()) {
            sql += " AND fecha_reporte >= ? ";
            params.add(fechaInicio);
        }
        
        if (fechaFin != null && !fechaFin.isEmpty()) {
            sql += " AND fecha_reporte <= ? ";
            params.add(fechaFin);
        }
        
        sql += " ORDER BY codigo_liquidez, fecha_reporte";
        
        try {
            return jdbcTemplate.query(sql, params.toArray(), (rs, rowNum) -> {
                L08ReportData data = new L08ReportData();
                data.setId(rs.getLong("id"));
                data.setCodigoLiquidez(rs.getInt("codigo_liquidez"));
                data.setTipoIdentificacion(rs.getString("tipo_identificacion"));
                data.setIdentificacionEntidad(rs.getString("identificacion_entidad"));
                data.setTipoInstrumento(rs.getInt("tipo_instrumento"));
                data.setCalificacionEntidad(rs.getInt("calificacion_entidad"));
                data.setCalificadoraRiesgo(rs.getInt("calificadora_riesgo"));
                data.setValorLunes(rs.getBigDecimal("valor_lunes"));
                data.setValorMartes(rs.getBigDecimal("valor_martes"));
                data.setValorMiercoles(rs.getBigDecimal("valor_miercoles"));
                data.setValorJueves(rs.getBigDecimal("valor_jueves"));
                data.setValorViernes(rs.getBigDecimal("valor_viernes"));
                data.setFechaReporte(rs.getDate("fecha_reporte").toLocalDate());
                data.setEntidadCodigo(rs.getString("entidad_codigo"));
                return data;
            });
        } catch (Exception e) {
            log.error("Error consultando datos L08 - Liquidez Estructural", e);
            throw new RuntimeException("Error obteniendo datos del reporte L08 - Liquidez Estructural", e);
        }
    }

    public L08ReportResponse generateL08Report(L08ReportRequest request) {
        log.info("Generando reporte L08: {}", request);
        
        try {
            // Obtener datos
            List<L08ReportData> data = getL08Data(
                request.getFechaInicio() != null ? request.getFechaInicio().toString() : null,
                request.getFechaFin() != null ? request.getFechaFin().toString() : null
            );
            
            // Generar respuesta
            L08ReportResponse response = new L08ReportResponse();
            response.setIdReporte(UUID.randomUUID().toString());
            response.setNombreReporte("L08 - Reporte de Créditos");
            response.setEstado("COMPLETADO");
            response.setFechaGeneracion(LocalDateTime.now());
            response.setUsuarioGenerador(request.getUsuarioGenerador());
            response.setRegistrosProcesados((long) data.size());
            response.setRegistrosValidos((long) data.size());
            response.setRegistrosConErrores(0L);
            response.setFormatoArchivo("TXT");
            response.setObservaciones("Reporte generado exitosamente");
            
            // Generar nombre de archivo
            String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
            response.setArchivoGenerado("L08_" + timestamp + ".txt");
            response.setRutaArchivo("/reports/L08_" + timestamp + ".txt");
            
            log.info("Reporte L08 generado exitosamente: {}", response.getIdReporte());
            return response;
            
        } catch (Exception e) {
            log.error("Error generando reporte L08", e);
            throw new RuntimeException("Error generando reporte L08", e);
        }
    }

    public List<L08ReportResponse> getL08History() {
        log.info("Obteniendo historial de reportes L08");
        
        // Por ahora retornamos datos mock
        List<L08ReportResponse> history = new ArrayList<>();
        
        for (int i = 1; i <= 5; i++) {
            L08ReportResponse report = new L08ReportResponse();
            report.setIdReporte("L08_" + i);
            report.setNombreReporte("L08 - Reporte de Créditos");
            report.setEstado("COMPLETADO");
            report.setFechaGeneracion(LocalDateTime.now().minusDays(i));
            report.setUsuarioGenerador("usuario" + i);
            report.setArchivoGenerado("L08_" + LocalDate.now().minusDays(i).format(DateTimeFormatter.ofPattern("yyyyMMdd")) + ".txt");
            report.setRegistrosProcesados(1000L + i * 100);
            report.setRegistrosValidos(950L + i * 95);
            report.setRegistrosConErrores(50L + i * 5);
            report.setFormatoArchivo("TXT");
            history.add(report);
        }
        
        return history;
    }

    /**
     * Genera el contenido TXT del reporte L08 según especificaciones SB
     */
    public String generateL08Txt(String fechaInicio, String fechaFin) {
        List<L08ReportData> data = getL08Data(fechaInicio, fechaFin);
        if (data.isEmpty()) {
            throw new RuntimeException("No hay datos para exportar L08");
        }
        // Tomar cabecera de primer registro
        String codigoEntidad = data.get(0).getEntidadCodigo();
        String fechaCorte = data.get(0).getFechaReporte().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        int totalRegistros = data.size();
        StringBuilder sb = new StringBuilder();
        sb.append(String.format("L08|%s|%s|%08d\n", codigoEntidad, fechaCorte, totalRegistros));
        for (L08ReportData d : data) {
            sb.append(String.format("%06d|%s|%s|%02d|%02d|%02d|%s|%s|%s|%s|%s\n",
                d.getCodigoLiquidez(),
                d.getTipoIdentificacion(),
                d.getIdentificacionEntidad(),
                d.getTipoInstrumento(),
                d.getCalificacionEntidad(),
                d.getCalificadoraRiesgo(),
                d.getValorLunes(),
                d.getValorMartes(),
                d.getValorMiercoles(),
                d.getValorJueves(),
                d.getValorViernes()
            ));
        }
        return sb.toString();
    }
} 