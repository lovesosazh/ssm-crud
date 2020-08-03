package com.lovesosa.service;

import com.lovesosa.bean.Employee;

import java.util.List;

/**
 * @author lovesosa
 */
public interface EmployeeService {


    List<Employee> getAll();

    int saveEmp(Employee employee);

    long getEmpbyName(String empName);

    Employee getEmpById(Integer empid);

    void updateEmp(Employee employee);

    void deleteById(Integer empId);

    void deleteBatch(List<Integer> list);
}
