package com.lovesosa.controller;

import com.lovesosa.bean.Department;
import com.lovesosa.commons.R;
import com.lovesosa.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * @author lovesosa
 */
@RestController
public class DepartmentController {


    @Autowired
    private DepartmentService departmentService;

    @GetMapping("/depts")
    public R<Department> depts() {
        List<Department> list = departmentService.getDepts();
        return R.success().data("depts", list);
    }
}
