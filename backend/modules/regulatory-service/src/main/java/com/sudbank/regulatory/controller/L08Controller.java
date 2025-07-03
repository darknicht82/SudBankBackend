package com.sudbank.regulatory.controller;

import com.sudbank.regulatory.dto.L08DTO;
import com.sudbank.regulatory.service.L08Service;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.core.io.Resource;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/api/l08")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class L08Controller {
    private final L08Service l08Service;

    @GetMapping("/test")
    public ResponseEntity<Map<String, Object>> test() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "success");
        response.put("message", "L08 Controller funcionando correctamente");
        response.put("timestamp", LocalDate.now().toString());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/summary")
    public ResponseEntity<Map<String, Object>> getSummary() {
        Map<String, Object> summary = new HashMap<>();
        summary.put("totalRegistros", 1250);
        summary.put("valorTotalLunes", 1500000000);
        summary.put("valorTotalViernes", 1550000000);
        summary.put("variacionSemanal", 3.33);
        summary.put("cumplimiento", 98.5);
        return ResponseEntity.ok(summary);
    }

    @PostMapping("/report")
    public ResponseEntity<Map<String, Object>> generateReport(@RequestBody Map<String, Object> request) {
        Map<String, Object> response = new HashMap<>();
        Map<String, Object> registro = new HashMap<>();
        registro.put("id", 1);
        registro.put("codigoLiquidez", "L08-001");
        registro.put("identificacionEntidad", "Banco A");
        registro.put("tipoInstrumento", "DEPOSITOS");
        registro.put("calificacionEntidad", "A");
        registro.put("fechaReporte", "2024-01-15");
        registro.put("valorLunes", 1000000);
        registro.put("valorMartes", 1050000);
        registro.put("valorMiercoles", 1100000);
        registro.put("valorJueves", 1150000);
        registro.put("valorViernes", 1200000);
        response.put("datos", List.of(registro));
        response.put("totalRegistros", 1);
        response.put("valorTotalLunes", 1000000);
        response.put("valorTotalViernes", 1200000);
        response.put("variacionSemanal", 20.0);
        response.put("cumplimiento", 100.0);
        return ResponseEntity.ok(response);
    }

    @GetMapping
    public List<L08DTO> getByFecha(@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha) {
        return l08Service.findByFecha(fecha);
    }

    @PostMapping
    public L08DTO create(@RequestBody L08DTO dto) {
        return l08Service.create(dto);
    }

    @PutMapping("/{id}")
    public L08DTO update(@PathVariable Long id, @RequestBody L08DTO dto) {
        return l08Service.update(id, dto);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        l08Service.delete(id);
    }

    @PostMapping("/validar")
    public ResponseEntity<?> validar(@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha) {
        return ResponseEntity.ok(l08Service.validar(fecha));
    }

    @PostMapping("/generar-txt")
    public ResponseEntity<Resource> generarTxt(@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha) {
        Resource txt = l08Service.generarTxt(fecha);
        return ResponseEntity.ok()
            .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=L08_" + fecha + ".txt")
            .body(txt);
    }

    @PostMapping("/archivar")
    public void archivar(@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha) {
        l08Service.archivar(fecha);
    }

    @GetMapping("/export")
    public ResponseEntity<String> exportL08Txt(
            @RequestParam String fechaInicio,
            @RequestParam String fechaFin) {
        try {
            // Llamar al sqlserver-adapter para obtener el TXT
            String txtContent = l08Service.exportL08Txt(fechaInicio, fechaFin);
            return ResponseEntity.ok()
                .header("Content-Type", "text/plain; charset=utf-8")
                .header("Content-Disposition", "attachment; filename=L08L0001" + 
                    LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("ddMMyyyy")) + ".txt")
                .body(txtContent);
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                .body("Error generando TXT: " + e.getMessage());
        }
    }
} 