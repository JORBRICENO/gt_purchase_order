using {com.globaltalent.purchaseorder as entitites} from '../db/schema';

using {API_COMPANYCODE_SRV} from './external/API_COMPANYCODE_SRV';
using {CE_PURCHASINGORGANIZATION_0001 as Organization} from './external/CE_PURCHASINGORGANIZATION_0001';
using {API_BUSINESS_PARTNER as BusinessPartner} from './external/API_BUSINESS_PARTNER';
using {CE_PURCHASINGGROUP_0001 as Group} from './external/CE_PURCHASINGGROUP_0001';
using {ZCE_PURCHASEORDERTYPE as PurchaseOrderType} from './external/ZCE_PURCHASEORDERTYPE';

service PurchaseOrder {

    entity PurchaseOrder     as projection on entitites.PurchaseOrderHeader;
    entity PurchaseOrderItem as projection on entitites.PurchaseOrderItem;

    /**Value Helps */
    @readonly
    entity VH_Suppliers      as projection on entitites.Suppliers;

    @readonly
    entity VH_Companies      as projection on entitites.Companies;

    @readonly
    entity VH_Organizations  as projection on entitites.Organizations;

    @readonly
    entity VH_OrderTypes     as projection on entitites.OrderTypes;

    @readonly
    entity VH_Groups         as projection on entitites.Groups
                                order by
                                    PurchasingGroup;

    // entity VH_Categories as projection on entitites.Categories;

    // entity VH_SubCategories as projection on entitites.SubCategories;

    /** Value Helps - External */
    @cds.persistence.exists
    @cds.persistence.skip
    entity VHE_Companies     as
        projection on API_COMPANYCODE_SRV.A_CompanyCode {
            key CompanyCode,
                CompanyCodeName,
                Country,
                CityName,
                Language
        };

    @cds.persistence.exists
    @cds.persistence.skip
    entity VHE_Organizations as
        projection on Organization.A_PurchasingOrganization {
            key PurchasingOrganization,
                PurchasingOrganizationName,
                CompanyCode
        }

    @cds.persistence.exists
    @cds.persistence.skip
    entity VHE_Groups as projection on Group.A_PurchasingGroup {
        key PurchasingGroup,
            PurchasingGroupName
    };

    @cds.persistence.exists
    @cds.persistence.skip
    entity VHE_Suppliers as projection on  BusinessPartner.A_Supplier {
        key Supplier,
            SupplierName,
            to_SupplierPurchasingOrg.PurchasingOrganization as PurchasingOrganization
    };
    @cds.persistence.exists
    @cds.persistence.skip
    entity VHE_PurchaseOrderTypes as projection on PurchaseOrderType.PurchaseOrderType {
        key PurchaseOrderType,
            PurchaseOrderTypeName
    }
};
