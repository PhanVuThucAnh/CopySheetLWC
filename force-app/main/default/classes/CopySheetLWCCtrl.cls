public with sharing class CopySheetLWCCtrl {
    // @AuraEnabled(cacheable=true)
    // public static List<Cycle__c> getCycleDetail(ID recordID){
    //     try {
    //         List<Cycle__c> cycleDetailList = [
    //             SELECT
    //              Name,
    //              Contact__c,
    //              Status__c
    //             FROM Cycle__c
    //             WHERE ID = :recordID
    //         ];
    //         return cycleDetailList;
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }
    
    @AuraEnabled
    public static Cycle__c copyCycle(Cycle__c copyCurrentCycle){
        try {
            copyCurrentCycle.StartDateA__c=system.Today();
            insert(copyCurrentCycle);
            return copyCurrentCycle;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}

// public with sharing class CopyEntrySheetCtrl {
//     private final ApexPages.StandardController ctrl;
//     private final Cycle__c cycle;

//     public CopyEntrySheetCtrl(ApexPages.StandardController ctrl) {
//         this.ctrl = ctrl;
//         this.cycle = (Cycle__c) ctrl.getRecord();
//     }

//     public String selected { get; set; }

//     public SelectOption[] options {
//         get {
//             if (options == null) {
//                 options = new SelectOption[] {};
//                 for (Cycle__c c : [
//                     select Id, Name
//                     from Cycle__c
//                     where Contact__c = :cycle.Contact__c and Id != :ctrl.getId()
//                     order by CycleStartDate__c desc, LastModifiedDate desc
//                 ]) {
//                     options.add(new SelectOption(c.Id, c.Name));
//                 }
//             }
//             return options;
//         }

//         private set;
//     }

//     public PageReference copy() {
//         try {
//             if (String.isBlank(selected)) {
//                 throw new CopyException('コピー元サイクルを選択してください');
//             }
//             if (cycle.Status__c == '支援終了') {
//                 throw new CopyException(System.Label.CannotCopyEntrySheet);
//             }
//             String[] columns = targetColumns();
//             String query = 'select ' + String.join(columns, ', ') + ' from Cycle__c where Id = :selected limit 1';
//             Cycle__c cycle_from = Database.query(query);
//             for (String column : columns) {
//                 cycle.put(column, cycle_from.get(column));
//             }
//             return ctrl.save();
//         } catch (Exception e) {
//             ApexPages.addMessages(e);
//             return null;
//         }
//     }

//     private class CopyException extends Exception { }

//     private String[] targetColumns() {
//         Set<String> columns = splitByNewline(System.Label.CycleCopyFieldName);
//         Set<String> prefixes = splitByNewline(System.Label.CycleCopyPrefix);
//         for (Schema.SObjectField f : Schema.SObjectType.Cycle__c.fields.getMap().values()) {
//             Schema.DescribeFieldResult fieldResult = f.getDescribe();
//             if (isTargetColumn(fieldResult.getLabel(), prefixes)) {
//                 columns.add(fieldResult.getName());
//             }
//         }
//         return new List<String>(columns);
//     }

//     private Boolean isTargetColumn(String label, Set<String> prefixes) {
//         for (String prefix : prefixes) {
//             if (label.startsWith(prefix)) {
//                 return true;
//             }
//         }
//         return false;
//     }

//     private Set<String> splitByNewline(String text) {
//         Set<String> result = new Set<String>();
//         for (String line : text.split('\n')) {
//             if (String.isNotBlank(line.trim())) {
//                 result.add(line.trim());
//             }
//         }
//         return result;
//     }
// }