package com.sudbank.regulatory.client;

import com.sudbank.regulatory.dto.L08ReportData;
import com.sudbank.regulatory.dto.L08ReportRequest;
import com.sudbank.regulatory.dto.L08ReportResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@FeignClient(name = "sqlserver-adapter", url = "${adapter.service.url}")
public interface SqlServerAdapterClient {

    @GetMapping("/api/regulatory/l08/data")
    List<L08ReportData> getL08Data(
            @RequestParam(value = "fechaInicio", required = false) String fechaInicio,
            @RequestParam(value = "fechaFin", required = false) String fechaFin);

    @PostMapping("/api/regulatory/l08/generate")
    L08ReportResponse generateL08Report(@RequestBody L08ReportRequest request);

    @GetMapping("/api/regulatory/l08/history")
    List<L08ReportResponse> getL08History();

    @GetMapping("/api/regulatory/l08/export")
    String exportL08Txt(
            @RequestParam("fechaInicio") String fechaInicio,
            @RequestParam("fechaFin") String fechaFin);

    @GetMapping("/api/regulatory/health")
    String health();
} 