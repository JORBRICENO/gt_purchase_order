namespace com.globaltalent.purchaseorder;

using {
    cuid,
    managed,
    sap.common.CodeList,
    sap.common.Languages,
    sap.common.Currencies
} from '@sap/cds/common';

using {API_COMPANYCODE_SRV as Company} from '../srv/external/API_COMPANYCODE_SRV';
using {CE_PURCHASINGORGANIZATION_0001 as Organization} from '../srv/external/CE_PURCHASINGORGANIZATION_0001';
using {API_BUSINESS_PARTNER as BusinessPartner} from '../srv/external/API_BUSINESS_PARTNER';
using {CE_PURCHASINGGROUP_0001 as Group} from '../srv/external/CE_PURCHASINGGROUP_0001';
using {ZCE_PURCHASEORDERTYPE as PurchaseOrderType} from '../srv/external/ZCE_PURCHASEORDERTYPE';

entity PurchaseOrderHeader : cuid, managed {
    key PurchaseOrder              : String(10) @Core.Computed: true;
        CompanyCode                : Association to Company.A_CompanyCode; //CompanyCode & CompanyCode_CompanyCode
        CompanyName                : String(25);
        PurchasingOrganization     : Association to Organization.A_PurchasingOrganization; //PurchasingOrganization & PurchasingOrganization_PurchasingOrganization
        PurchasingOrganizationName : String(20);
        PurchasingGroup            : Association to Group.A_PurchasingGroup; //PurchasingGroup & PurchasingGroup_ID
        PurchasingGroupName        : String(18);
        PurchaseOrderType          : Association to PurchaseOrderType.PurchaseOrderType; //PurchaseOrderType & PurchaseOrderType_ID
        PurchaseOrderTypeName      : String(20);
        Supplier                   : Association to BusinessPartner.A_SupplierPurchasingOrg; //Supplier & Supplier_Supplier
        SupplierName               : String(80);
        Language                   : Association to Languages default 'EN'; //Language_code (EN,ES,...)
        PurchaseOrderDate          : Date;
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
