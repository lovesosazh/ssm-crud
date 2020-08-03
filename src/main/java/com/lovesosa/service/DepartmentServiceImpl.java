package com.lovesosa.service;

import com.lovesosa.bean.Department;
import com.lovesosa.dao.DepartmentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author lovesosa
 */
@Service
public class DepartmentServiceImpl implements DepartmentService {

    @Autowired
    private DepartmentMapper departmentMapper;

    @Override
    public List<Department> getDepts() {
        return departmentMapper.selectByExample(null);
    }
}
