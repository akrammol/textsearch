package com.serrala.textserach;

import com.serrala.textserach.service.TextService;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class App {
    public static void main(String[] args) {

        TextService textService = new TextService();
        List<String> tableList = new ArrayList<>();
        tableList.add("A");
        tableList.add("B");
        tableList.add("C");
        Map<String, List<String>> strings = textService.stringListResult("jo%nson", tableList, "name", 100);
        System.out.println(strings);
    }
}