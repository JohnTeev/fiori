using CatalogService as service from '../../srv/interaction_srv';
annotate service.AnomalyDetections with @(

// 1 - Object Page

UI.FieldGroup #BasicInfo : {
    $Type : 'UI.FieldGroupType',
    Data : [
        {
            $Type : 'UI.DataField',
            Label : 'Document Number',
            Value : data_key,
            ![@Common.FieldControl] : #ReadOnly
        },
        {
            $Type : 'UI.DataField',
            Label : 'Company Code',
            Value : company_code,
            ![@Common.FieldControl] : #ReadOnly
        },
        {
            $Type : 'UI.DataField',
            Label : 'Process Area',
            Value : process_area,
            ![@Common.FieldControl] : #ReadOnly
        },
        {
            $Type : 'UI.DataField',
            Label : 'Model Name',
            Value : model_name,
            ![@Common.FieldControl] : #ReadOnly
        },
    ],
},

UI.FieldGroup #AnomalyDetails : {
    $Type : 'UI.FieldGroupType',
    Data : [
        {
                $Type : 'UI.DataField',
                Value : status_code,
                Criticality : status.code,
                CriticalityRepresentation : #WithIcon,
                Label : 'Status'
        },
        {
            $Type : 'UI.DataField',
            Label : 'Certainty Score',
            Value : score,
            ![@Common.FieldControl] : #ReadOnly
        },
        {
            $Type : 'UI.DataField',
            Label : 'Identified Date',
            Value : identified_date,
            ![@Common.FieldControl] : #ReadOnly
        },
        {
            $Type : 'UI.DataField',
            Label : 'Last Update',
            Value : last_update,
            ![@Common.FieldControl] : #ReadOnly
        },
    ],
},


UI.FieldGroup #AdditionalInfo : {
    $Type : 'UI.FieldGroupType',
    Data : [
        {
            $Type : 'UI.DataField',
            Label : 'Assignee',
            Value : assignee,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Close Category',
            Value : close_category_code,
            ![@Common.FieldControl] : {$edmJson: {
                $If: [
                    {$Eq: [{$Path: 'status_code'}, '3']},
                    7,
                    1
                ]
            }}
        },
        {
            $Type : 'UI.DataField',
            Label : 'Notes',
            Value : notes,
            ![@Common.FieldControl] : {$edmJson: {
                $If: [
                    {$Or: [
                        {$Eq: [{$Path: 'status_code'}, '2']},
                        {$Eq: [{$Path: 'status_code'}, '3']}
                    ]},
                    7,
                    3
                ]
            }}
        },
    ],
},

UI.Facets : [
    {
        $Type : 'UI.ReferenceFacet',
        ID : 'BasicInfoFacet',
        Label : 'Basic Information',
        Target : '@UI.FieldGroup#BasicInfo',
    },
    {
        $Type : 'UI.ReferenceFacet',
        ID : 'AnomalyDetailsFacet',
        Label : 'Anomaly Details',
        Target : '@UI.FieldGroup#AnomalyDetails',
    },
    {
        $Type : 'UI.ReferenceFacet',
        ID : 'AdditionalInfoFacet',
        Label : 'Additional Information',
        Target : '@UI.FieldGroup#AdditionalInfo',
    },
],

// 2 - List Report

UI.LineItem : [
        {
            $Type : 'UI.DataFieldWithUrl',
            Label : 'Document Number',
            Value : data_key,
            Url : 'https://www.google.com/',
            ![@UI.Importance] : #High,
            ![@HTML5.CssDefaults] : {width : '15%'}
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Label : 'Certainty Score',
            Target : '@UI.Chart#CertaintyScoreChart',
            ![@UI.Importance] : #High,
            ![@HTML5.CssDefaults] : {width : '10%'}
        },
        {
            $Type : 'UI.DataField',
            Value : status.name,
            Criticality : status.code,
            CriticalityRepresentation : #WithIcon,
            Label : 'Status',
            ![@UI.Importance] : #High,
            ![@HTML5.CssDefaults] : {width : '15%'},
        },
        {
            $Type : 'UI.DataField',
            Label : 'Company Code',
            Value : company_code,
            ![@UI.Importance] : #High,
            ![@HTML5.CssDefaults] : {width : '10%'}
        },
        {
            $Type : 'UI.DataField',
            Label : 'Process Area',
            Value : process_area,
            ![@UI.Importance] : #Medium,
            ![@HTML5.CssDefaults] : {width : '10%'}
        },
        {
            $Type : 'UI.DataField',
            Label : 'Identified Date',
            Value : identified_date,
            ![@UI.Importance] : #Medium,
            ![@HTML5.CssDefaults] : {width : '10%'}
        },
        {
            $Type : 'UI.DataField',
            Label : 'Assignee',
            Value : assignee,
            ![@UI.Importance] : #Medium,
            ![@HTML5.CssDefaults] : {width : '20%'}
        },
        {
            $Type : 'UI.DataField',
            Label : 'Model Name',
            Value : model_name,
            ![@UI.Importance] : #Low,
            ![@HTML5.CssDefaults] : {width : '25%'}
        }
            
    ],
    UI.SelectionFields : [
        company_code,
        process_area,
        identified_date
    ],
    UI.PresentationVariant : {
        SortOrder : [
            {
                Property : status.name,
                Descending : false
            }
        ],
        Visualizations : ['@UI.LineItem']
    },
    DataPoint #criticality : {
        Value : status.code,
        Criticality : {
            $Type : 'UI.CriticalityType',
            Path : 'status.code'
        }
    },
    UI.Chart #CertaintyScoreChart : {
        Title : 'Certainty Score',
        Description : 'Certainty Score as a percentage',
        ChartType : #Donut,
        Measures : [
            score
        ],
        MeasureAttributes : [
            {
                $Type : 'UI.ChartMeasureAttributeType',
                Measure : score,
                Role : #Axis1,
                DataPoint : '@UI.DataPoint#CertaintyScore'
            }
        ]
    },
    UI.DataPoint #CertaintyScore : {
        Value : score,
        TargetValue : 100,
        Criticality : score
    }
);

annotate CatalogService.AnomalyDetections with {
    @Common.Label: 'Document Number'
    data_key;

    @Common.Label: 'Company Code'
    company_code;

    @Common.Label: 'Process Area'
    process_area;

    @Common.Label: 'Model Name'
    model_name;

    @Common.Label: 'Score'
    @Measures.Unit:'%'
    score;

    @Common.Label: 'Status'
    status;

    @Common.Label: 'Identified Date'
    identified_date;

    @Common.Label: 'Last Update'
    last_update;

    @Common.Label: 'Assignee'
    assignee;

    @Common.Label: 'Notes'
    notes;

    @Common.Label: 'Close Category'
    close_category;

    @Common.Label: 'ID'
    id;
};

annotate service.AnomalyDetections with {
    @UI.Hidden: true
    id;
    score;
};

annotate CatalogService.AnomalyDetections with @(
    Capabilities: {
        InsertRestrictions: {
            Insertable: false
        },
        DeleteRestrictions: {
            Deletable: false
        },
        UpdateRestrictions: {
            Updatable: true
        }
    }
);

annotate service.AnomalyDetections with @(
    UI: {
        HeaderInfo: {
            TypeName: 'Anomaly Worklist, powered by Teev AI',
            TypeNamePlural: 'Anomalies',
            Title: {
                $Type: 'UI.DataField',
                Value: data_key
            },
            Description: {
                $Type: 'UI.DataField',
                Value: status_code
            }
        }
    },
    
);

annotate service.AnomalyDetections with {    
    assignee @title: 'Assignee';
    close_category @title: 'Close Category';
    notes @title: 'Notes' @UI.MultiLineText: true;

};

annotate service.AnomalyDetections with {
    status @(
        Common.ValueListWithFixedValues: true,
        Common.ValueList : {
            Label: 'Status',
            CollectionPath : 'StatusOptions',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : status_code,
                    ValueListProperty : 'code'
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'name'
                },

            ]
        },
        Common.Text: {
            $value: status.name,
            ![@UI.TextArrangement] : #TextOnly
        }
    );

    close_category @(
        Common.ValueListWithFixedValues: true,
        Common.ValueList : {
            Label: 'Close Category',
            CollectionPath : 'CloseCategoryOptions',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'name'
                }
            ]
        },
        Common.Text: close_category.name,
        Common.TextArrangement: #TextOnly
    );
}

annotate service.StatusOptions with {
    code @UI.Hidden;
}
