package com.sudbank.regulatory.controller;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.time.LocalDate;

@RestController
@RequestMapping("/api/test")
@CrossOrigin(origins = "*")
public class TestController {

    @GetMapping("/ping")
    public ResponseEntity<Map<String, Object>> ping() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "success");
        response.put("message", "Backend funcionando correctamente");
        response.put("timestamp", LocalDate.now().toString());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/l08/summary")
    public ResponseEntity<Map<String, Object>> getL08Summary() {
        Map<String, Object> summary = new HashMap<>();
        summary.put("totalRegistros", 1250);
        summary.put("valorTotalLunes", 1500000000);
        summary.put("valorTotalViernes", 1550000000);
        summary.put("variacionSemanal", 3.33);
        summary.put("cumplimiento", 98.5);
        return ResponseEntity.ok(summary);
    }

    @PostMapping("/l08/report")
    public ResponseEntity<Map<String, Object>> generateL08Report(@RequestBody Map<String, Object> request) {
        Map<String, Object> response = new HashMap<>();
        Map<String, Object> registro1 = new HashMap<>();
        registro1.put("id", 1);
        registro1.put("codigoLiquidez", "L08-001");
        registro1.put("identificacionEntidad", "Banco A");
        registro1.put("tipoInstrumento", "DEPOSITOS");
        registro1.put("calificacionEntidad", "A");
        registro1.put("fechaReporte", "2024-01-15");
        registro1.put("valorLunes", 1000000);
        registro1.put("valorMartes", 1050000);
        registro1.put("valorMiercoles", 1100000);
        registro1.put("valorJueves", 1150000);
        registro1.put("valorViernes", 1200000);
        Map<String, Object> registro2 = new HashMap<>();
        registro2.put("id", 2);
        registro2.put("codigoLiquidez", "L08-002");
        registro2.put("identificacionEntidad", "Banco B");
        registro2.put("tipoInstrumento", "PRESTAMOS");
        registro2.put("calificacionEntidad", "B");
        registro2.put("fechaReporte", "2024-01-15");
        registro2.put("valorLunes", 2000000);
        registro2.put("valorMartes", 2100000);
        registro2.put("valorMiercoles", 2200000);
        registro2.put("valorJueves", 2300000);
        registro2.put("valorViernes", 2400000);
        response.put("datos", List.of(registro1, registro2));
        response.put("totalRegistros", 2);
        response.put("valorTotalLunes", 3000000);
        response.put("valorTotalViernes", 3600000);
        response.put("variacionSemanal", 20.0);
        response.put("cumplimiento", 100.0);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/l08/history")
    public ResponseEntity<List<Map<String, Object>>> getL08History() {
        Map<String, Object> registro1 = new HashMap<>();
        registro1.put("id", 1);
        registro1.put("codigoLiquidez", "L08-001");
        registro1.put("identificacionEntidad", "Banco A");
        registro1.put("tipoInstrumento", "DEPOSITOS");
        registro1.put("calificacionEntidad", "A");
        registro1.put("fechaReporte", "2024-01-14");
        registro1.put("valorLunes", 950000);
        registro1.put("valorMartes", 1000000);
        registro1.put("valorMiercoles", 1050000);
        registro1.put("valorJueves", 1100000);
        registro1.put("valorViernes", 1150000);
        Map<String, Object> registro2 = new HashMap<>();
        registro2.put("id", 2);
        registro2.put("codigoLiquidez", "L08-002");
        registro2.put("identificacionEntidad", "Banco B");
        registro2.put("tipoInstrumento", "PRESTAMOS");
        registro2.put("calificacionEntidad", "B");
        registro2.put("fechaReporte", "2024-01-13");
        registro2.put("valorLunes", 1800000);
        registro2.put("valorMartes", 1900000);
        registro2.put("valorMiercoles", 2000000);
        registro2.put("valorJueves", 2100000);
        registro2.put("valorViernes", 2200000);
        List<Map<String, Object>> history = List.of(registro1, registro2);
        return ResponseEntity.ok(history);
    }
} 