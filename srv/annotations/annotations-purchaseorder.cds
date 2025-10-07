using {PurchaseOrder as pos} from '../service';

using from './annotations-purchaseorderitem';

annotate pos.PurchaseOrder with @odata.draft.enabled;

annotate pos.PurchaseOrder with {
    PurchaseOrder              @Common.Label: 'Purchase Order';
    PurchaseOrderType          @title       : 'Purchase Order Type';
    PurchasingOrganization     @title       : 'Purchasing Organization';
    CompanyCode                @title       : 'Company Code';
    Supplier                   @title       : 'Supplier';
    Language                   @title       : 'Language';
    PurchaseOrderDate          @title       : 'Purchase Date';
    PurchasingGroup            @title       : 'Purchasing Group';
    DocumentCurrency           @title       : 'Currency';
    PurchasingProcessingStatus @title       : 'Overall Status';
};

annotate pos.PurchaseOrder with {
    PurchasingProcessingStatus @Common: {
        Text           : PurchasingProcessingStatus.name,
        TextArrangement: #TextOnly
    };
    CompanyCode                @Common: {
        Text           : CompanyName,
        TextArrangement: #TextOnly,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VHE_Companies',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: CompanyCode_CompanyCode,
                    ValueListProperty: 'CompanyCode'
                },
                {
                    $Type : 'Common.ValueListParameterOut',
                    LocalDataProperty : CompanyName,
                    ValueListProperty : 'CompanyCodeName'
                }
            ]
        }
    };
    PurchasingOrganization     @Common: {
        Text           : PurchasingOrganizationName,
        TextArrangement: #TextOnly,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VHE_Organizations',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterIn',
                    LocalDataProperty: CompanyCode_CompanyCode,
                    ValueListProperty: 'CompanyCode'
                },
                {
                    $Type : 'Common.ValueListParameterOut',
                    LocalDataProperty : PurchasingOrganization_PurchasingOrganization,
                    ValueListProperty : 'PurchasingOrganization'
                },
                {
                    $Type : 'Common.ValueListParameterOut',
                    LocalDataProperty : PurchasingOrganizationName,
                    ValueListProperty : 'PurchasingOrganizationName'
                }
            ]
        }
    };
    PurchaseOrderType          @Common: {
        Text           : PurchaseOrderType.Description,
        TextArrangement: #TextOnly,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_OrderTypes',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: PurchaseOrderType_ID,
                ValueListProperty: 'ID'
            }]
        }
    };
    PurchasingGroup @Common: {
        Text : PurchasingGroup.PurchasingGroup,
        TextArrangement : #TextOnly,
        ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'VH_Groups',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : PurchasingGroup_ID,
                    ValueListProperty : 'ID'
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'Description'
                }
            ]
        }
    };
    Supplier                   @Common: {
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VHE_Suppliers',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: Supplier_Supplier,
                ValueListProperty: 'Supplier'
            }]
        },
    };
    // Category @Common: {
    //     ValueList : {
    //         $Type : 'Common.ValueListType',
    //         CollectionPath : 'VH_Categories',
    //         Parameters : [
    //             {
    //                 $Type : 'Common.ValueListParameterInOut',
    //                 LocalDataProperty : Category_ID,
    //                 ValueListProperty : 'ID'
    //             },
    //         ],
    //     },
    // };
    // SubCategory @Common : { 
    //     ValueList : {
    //         $Type : 'Common.ValueListType',
    //         CollectionPath : 'VH_SubCategories',
    //         Parameters : [
    //            {
    //                $Type : 'Common.ValueListParameterIn',
    //                LocalDataProperty : Category_ID,
    //                ValueListProperty : 'Category_ID'
    //            },
    //            {
    //                $Type : 'Common.ValueListParameterOut',
    //                LocalDataProperty : SubCategory_ID,
    //                ValueListProperty : 'ID'
    //            }
    //         ]
    //     }
    //  }
};


annotate pos.PurchaseOrder with @(
    UI.SelectionFields               : [
        CompanyCode_CompanyCode,
        PurchasingOrganization_PurchasingOrganization,
        PurchaseOrder,
        PurchaseOrderType_ID,
        Supplier_Supplier,
        Language_code,
        DocumentCurrency_code,
        PurchasingProcessingStatus_code,
        // Category_ID,
        // SubCategory_ID
    ],
    UI.HeaderInfo                    : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Purchase Order',
        TypeNamePlural: 'Purchase Orders',
        Title         : {
            $Type: 'UI.DataField',
            Value: PurchaseOrder
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: PurchaseOrderDate
        }
    },
    UI.LineItem                      : [
        {
            $Type             : 'UI.DataField',
            Value             : PurchaseOrder,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '8rem'
            }
        },
        {
            $Type             : 'UI.DataField',
            Value             : PurchaseOrderType_ID,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '12rem'
            }
        },
        {
            $Type             : 'UI.DataField',
            Value             : PurchasingOrganization_PurchasingOrganization,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '12rem'
            }
        },
        {
            $Type             : 'UI.DataField',
            Value             : PurchaseOrderDate,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '12rem'
            }
        },
        {
            $Type             : 'UI.DataField',
            Value             : CompanyCode_CompanyCode,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '8rem'
            }
        },
        {
            $Type             : 'UI.DataField',
            Value             : Supplier_Supplier,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            }
        },
        {
            $Type             : 'UI.DataField',
            Value             : PurchasingProcessingStatus_code,
            Criticality       : PurchasingProcessingStatus.criticality,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            }
        }
    ],
    UI.FieldGroup #OrganizationalData: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: CompanyCode_CompanyCode
            },
            {
                $Type: 'UI.DataField',
                Value: PurchasingOrganization_PurchasingOrganization
            },
            {
                $Type: 'UI.DataField',
                Value: PurchasingGroup_ID
            }
        ],
    },
    UI.FieldGroup #BasicData         : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: Supplier_Supplier
            },
            {
                $Type: 'UI.DataField',
                Value: PurchaseOrderType_ID
            },
            {
                $Type: 'UI.DataField',
                Value: PurchaseOrderDate
            },
            {
                $Type: 'UI.DataField',
                Value: DocumentCurrency_code
            }
        ],
    },
    UI.FieldGroup #StatusInformation : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: PurchasingProcessingStatus_code,
                @Common.FieldControl : {
                    $edmJson: {
                        $If:[
                            {
                                $Eq:[
                                    {
                                        $Path: 'IsActiveEntity'
                                    },
                                    false
                                ]
                            },
                            1,
                            3
                        ]
                    }
                }
            }
        ]
    },
    UI.Facets                        : [
        {
            $Type : 'UI.CollectionFacet',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#OrganizationalData',
                    Label : 'Organizational Data',
                    ID    : 'OrganizationalData'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#BasicData',
                    Label : 'Basic Data',
                    ID    : 'BasicData'
                }
            ],
            Label : 'General Informatiom'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#StatusInformation',
            Label : 'Status Information',
            ID    : 'StatusInformation'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'to_PurchaseOrderItem/@UI.LineItem',
            Label : 'Items',
            ID    : 'ToItems'
        }
    ],
);
