package com.javadevelopment.restful;


import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.ArrayList;
import java.util.List;

@org.springframework.web.bind.annotation.RestController
@RequestMapping("/api")
public class RestController {

    @GetMapping("/v1/testing-data")
    public ResponseEntity<List<TestData>> getMyInvoices(HttpServletRequest request) {
        List<TestData> items = new ArrayList<>();
        for (int i = 1; i <= 10; i++) {
            items.add(new TestData(i, "Item " + i, Math.round((Math.random() * 1000.0) * 100.0) / 100.0));
        }
        return ResponseEntity.ok().body(items);
    }

}
