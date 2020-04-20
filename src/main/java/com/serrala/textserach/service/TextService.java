package com.serrala.textserach.service;

import com.serrala.textserach.dao.TextDao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TextService {

    /**
     * result list of the search.
     *
     * @param searchterm the word that you want to search.
     * @param tableNames name of the tables for searching the word .
     * @param columnName name of table's column for searching the word .
     * @param limitText  limit characters before and after the actual location of the hit.
     * @return Map of table name and search result list .
     */
    public Map<String, List<String>> stringListResult(String searchterm, List<String> tableNames, String columnName, int limitText) {
        TextDao dao = new TextDao();

        Map<String, List<String>> searchResult = new HashMap<>();
        for (String tab : tableNames) {
            List<String> serralaSearchFunc = dao.getSerralaSearchFunc(tab, searchterm, columnName, limitText);
            if (serralaSearchFunc != null)
                searchResult.put("table name is : " + tab + (columnName != null ? " column name is : " + columnName : "")
                        , serralaSearchFunc);
        }
        return searchResult;
    }
}
