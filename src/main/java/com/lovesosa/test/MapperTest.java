package com.lovesosa.test;


import com.lovesosa.bean.Department;
import com.lovesosa.bean.Employee;
import com.lovesosa.dao.DepartmentMapper;
import com.lovesosa.dao.EmployeeMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * @author lovesosa
 */
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
@RunWith(SpringJUnit4ClassRunner.class)
public class MapperTest {


    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Test
    public void testCRUD() {
        Department department1 = new Department(null, "设计部");
        Department department2 = new Department(null, "数据采集部");
        departmentMapper.insertSelective(department1);
        departmentMapper.insertSelective(department2);
    }


    @Test
    public void testEmp() {
        employeeMapper.insertSelective(new Employee(null, "Backer", "M", "Backer@11.com", 1));
    }





}
