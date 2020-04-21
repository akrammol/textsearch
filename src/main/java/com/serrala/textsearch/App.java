package com.serrala.textsearch;

import com.serrala.textsearch.service.TextService;

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
        Map<String, List<String>> strings = textService.stringListResult("jo**son", tableList, "name", 100);
        System.out.println(strings);
    }
}
