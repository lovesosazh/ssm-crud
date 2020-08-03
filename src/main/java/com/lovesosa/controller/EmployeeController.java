package com.lovesosa.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.lovesosa.bean.Employee;
import com.lovesosa.commons.R;
import com.lovesosa.service.EmployeeService;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.*;

/**
 * @author lovesosa
 */
@Log4j
@RestController
public class EmployeeController {

    @Autowired
    private EmployeeService employeeService;

//    @GetMapping("/emps")
//    public String getEmps(@RequestParam(value = "pageNo", defaultValue = "1") Integer pageNo,
//                          @RequestParam(value = "pageSize", required = false, defaultValue = "5") Integer pageSize,
//                          Map map) {
//        PageHelper.startPage(pageNo, pageSize);
//        List<Employee> employees = employeeService.getAll();
//        PageInfo<Employee> pageInfo = new PageInfo<>(employees, 5);
//        map.put("pageInfo", pageInfo);
//        return "list";
//    }



    @GetMapping("/emps")
    public R<PageInfo<Employee>> getEmpsWithJson(@RequestParam(value = "pageNo", defaultValue = "1") Integer pageNo,
                             @RequestParam(value = "pageSize", required = false, defaultValue = "5") Integer pageSize) {

        PageHelper.startPage(pageNo, pageSize);
        List<Employee> employees = employeeService.getAll();
        PageInfo<Employee> pageInfo = new PageInfo<>(employees, 5);
        return R.success().data("pageInfo", pageInfo);
    }



    @PostMapping("/emp")
    public R save(@Valid Employee employee, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            Map<String, Object> map = new HashMap<>();
            List<FieldError> fieldErrors = bindingResult.getFieldErrors();
            for (FieldError fieldError : fieldErrors) {
                log.error("错误字段名: " + fieldError.getField());
                log.error("错误信息: " + fieldError.getDefaultMessage());
                map.put(fieldError.getField(), fieldError.getDefaultMessage());
            }
            return R.fail().data("errorFields", map);
        } else {
            employeeService.saveEmp(employee);
            return R.success();
        }
    }


    @GetMapping("/checkEmpName")
    public R checkEmpName(@RequestParam("empName") String empName) {
        long count = employeeService.getEmpbyName(empName);
        if (count > 0) {
            return R.success().data("exists", true);
        } else {
            return R.success().data("exists", false);
        }
    }


    @GetMapping("/emp/{empId}")
    public R<Employee> getEmp(@PathVariable(name = "empId") Integer empid) {
        Employee employee = employeeService.getEmpById(empid);
        return R.success().data("emp", employee);
    }


    @PutMapping("/emp/{empId}")
    public R saveEmp(Employee employee) {
        employeeService.updateEmp(employee);
        return R.success();
    }


    @DeleteMapping("/emp/{ids}")
    public R delEmpById(@PathVariable("ids") String ids) {
        if (ids.contains("-")) {
            String[] str_ids = ids.split("-");
            List<Integer> list_ids = new ArrayList<>();
            for (String strId : str_ids) {
                list_ids.add(Integer.parseInt(strId));
            }
            employeeService.deleteBatch(list_ids);
        } else {
            int empId = Integer.parseInt(ids);
            employeeService.deleteById(empId);
        }

        return R.success();
    }



}
