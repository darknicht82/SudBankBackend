package com.sudbank.adapter.controller;

import com.sudbank.adapter.dto.L08ReportData;
import com.sudbank.adapter.dto.L08ReportRequest;
import com.sudbank.adapter.dto.L08ReportResponse;
import com.sudbank.adapter.service.RegulatoryDataService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/regulatory")
@RequiredArgsConstructor
@Slf4j
@CrossOrigin(origins = "*")
public class RegulatoryDataController {

    private final RegulatoryDataService regulatoryDataService;

    @GetMapping("/l08/data")
    public ResponseEntity<List<L08ReportData>> getL08Data(
            @RequestParam(required = false) String fechaInicio,
            @RequestParam(required = false) String fechaFin) {
        
        log.info("Obteniendo datos L08 - fechaInicio: {}, fechaFin: {}", fechaInicio, fechaFin);
        
        try {
            List<L08ReportData> data = regulatoryDataService.getL08Data(fechaInicio, fechaFin);
            return ResponseEntity.ok(data);
        } catch (Exception e) {
            log.error("Error obteniendo datos L08", e);
            return ResponseEntity.internalServerError().build();
        }
    }

    @PostMapping("/l08/generate")
    public ResponseEntity<L08ReportResponse> generateL08Report(@RequestBody L08ReportRequest request) {
        
        log.info("Generando reporte L08 - request: {}", request);
        
        try {
            L08ReportResponse response = regulatoryDataService.generateL08Report(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error generando reporte L08", e);
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/l08/history")
    public ResponseEntity<List<L08ReportResponse>> getL08History() {
        
        log.info("Obteniendo historial L08");
        
        try {
            List<L08ReportResponse> history = regulatoryDataService.getL08History();
            return ResponseEntity.ok(history);
        } catch (Exception e) {
            log.error("Error obteniendo historial L08", e);
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("SQL Server Adapter is running");
    }
} 