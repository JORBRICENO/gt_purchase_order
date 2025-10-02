using {PurchaseOrder} from '../service';

annotate PurchaseOrder.VH_OrderTypes with {
    @title : 'Order Types'
    ID @Common: {
        Text : Description,
        TextArrangement :  #TextOnly
    }
};
