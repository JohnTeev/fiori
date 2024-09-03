using app.interactions from '../db/interactions';
service CatalogService {
    @odata.draft.enabled: true
    entity AnomalyDetections as projection on interactions.AnomalyDetection;
    entity StatusOptions as projection on interactions.StatusOptions;
    entity CloseCategoryOptions as projection on interactions.CloseCategoryOptions;
}
