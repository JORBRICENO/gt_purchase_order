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
        PurchaseOrderType          : Association to OrderTypes; //PurchaseOrderType & PurchaseOrderType_ID
        PurchasingOrganization     : Association to Organizations;
        CompanyCode                : Association to Companies;
        Supplier                   : Association to Suppliers;
        Language                   : Association to Languages default 'EN'; //Language_code (EN,ES,...)
        PurchaseOrderDate          : Date;
        PurchasingGroup            : String(3);
        DocumentCurrency           : Association to Currencies default 'USD'; //DocumentCurrency_code (EUR,USD,COP,VES,...)
        PurchasingProcessingStatus : Association to OverallStatus; //OverallStatus_code
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
    key code : String  enum {
            H = 'En Retención'; // On Hold (Borrador) - Mapea a '01' de SAP
            A = 'Activo';       // Active (Aprobado y Enviado) - Mapea a '05' de SAP
            C = 'Completado';   // Completed - Mapea a '06' de SAP
            R = 'Rechazado';    // Rejected - Mapea a '03' de SAP
        };
    criticality: Integer;
};

entity Suppliers : cuid {
    Supplier: String(10);
    SupplierName: String(80);
};

entity Companies : cuid {
    CompanyCode: String(4);
    Description: String(80);
};

entity Organizations : cuid {
    PurchasingOrganization: String(4);
    Description: String(80);
};

entity OrderTypes: cuid {
    PurchaseOrderType: String(4);
    Description: String(80);
};