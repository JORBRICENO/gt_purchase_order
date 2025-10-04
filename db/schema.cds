namespace com.globaltalent.purchaseorder;

using {
    cuid,
    managed,
    sap.common.CodeList,
    sap.common.Languages,
    sap.common.Currencies
} from '@sap/cds/common';

entity PurchaseOrderHeader : cuid, managed {
    key PurchaseOrder              : String(10) @Core.Computed: true;
        CompanyCode                : Association to Companies;
        PurchasingOrganization     : Association to Organizations;
        PurchaseOrderType          : Association to OrderTypes; //PurchaseOrderType & PurchaseOrderType_ID
        Supplier                   : Association to Suppliers;
        Language                   : Association to Languages default 'EN'; //Language_code (EN,ES,...)
        PurchaseOrderDate          : Date;
        PurchasingGroup            : Association to Groups; //PurchasingGroup & PurchasingGroup_ID
        DocumentCurrency           : Association to Currencies default 'USD'; //DocumentCurrency_code (EUR,USD,COP,VES,...)
        PurchasingProcessingStatus : Association to OverallStatus; //OverallStatus_code
        // Category                   : Association to Categories;
        // SubCategory                : Association to SubCategories;
        to_PurchaseOrderItem       : Composition of many PurchaseOrderItem
                                         on to_PurchaseOrderItem.PurchaseOrder = $self;
};

entity PurchaseOrderItem : cuid {
    key PurchaseOrderItem     : String(5);
        PurchaseOrderItemText : String(40);
        Plant                 : String(4);
        StorageLocation       : String(4);
        Customer              : String(10);
        Material              : String(40);
        MaterialGroup         : String(9);
        ProductType           : String(2);
        NetPriceQuantity      : Decimal(12, 3);
        NetPriceAmount        : Decimal(5, 0);
        OrderQuantity         : Decimal(13, 2);
        OrderPriceUnit        : String(3);
        DocumentCurrency      : Association to Currencies;
        PurchaseOrder         : Association to PurchaseOrderHeader; //PurchaseOrder_ID & PurchaseOrder_PurchaseOrder
};


entity OverallStatus : CodeList {
    key code        : String enum {
            H = 'En Retención'; // On Hold (Borrador) - Mapea a '01' de SAP
            A = 'Activo'; // Active (Aprobado y Enviado) - Mapea a '05' de SAP
            C = 'Completado'; // Completed - Mapea a '06' de SAP
            R = 'Rechazado'; // Rejected - Mapea a '03' de SAP
        };
        criticality : Integer;
};

entity Companies : cuid {
    CompanyCode     : String(4);
    Description     : String(80);
    toOrganizations : Composition of many Organizations
                          on toOrganizations.Company = $self;
};

entity Organizations : cuid {
    PurchasingOrganization : String(4);
    Description            : String(80);
    Company                : Association to Companies;
};

entity OrderTypes : cuid {
    PurchaseOrderType : String(4);
    Description       : String(80);
};

entity Suppliers : cuid {
    Supplier     : String(10);
    SupplierName : String(80);
};

entity Groups : cuid {
    PurchasingGroup : String(3);
    Description     : String(80);
};

// entity Categories : cuid {
//     Category        : String(40);
//     toSubCategories : Composition of many SubCategories
//                           on toSubCategories.Category = $self;
// };

// entity SubCategories : cuid {
//     SubCategory : String(40);
//     Category    : Association to Categories;
// };
