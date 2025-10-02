using {com.globaltalent.purchaseorder as entitites} from '../db/schema';


service PurchaseOrder {
    entity PurchaseOrder as projection on entitites.PurchaseOrderHeader;
    entity PurchaseOrderItem as projection on entitites.PurchaseOrderItem;
    /**Value Helps */
    @readonly
    entity VH_Suppliers as projection on entitites.Suppliers;
    @readonly
    entity VH_Companies as projection on entitites.Companies;
    @readonly
    entity VH_Organizations as projection on entitites.Organizations;
    @readonly
    entity VH_OrderTypes as projection on entitites.OrderTypes;
};