using {PurchaseOrder} from '../service';

annotate PurchaseOrder.VH_Organizations with {
    @title : 'Organizations'
    ID @Common: {
        Text : Description,
        TextArrangement :  #TextOnly
    }
};
