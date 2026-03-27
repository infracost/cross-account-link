locals {
  # https://focus.finops.org/focus-specification/v1-2/
  focus_1_2_columns = [
    "AvailabilityZone",
    "BilledCost",
    "BillingAccountId",
    "BillingAccountName",
    "BillingAccountType",
    "BillingCurrency",
    "BillingPeriodEnd",
    "BillingPeriodStart",
    "CapacityReservationId",
    "CapacityReservationStatus",
    "ChargeCategory",
    "ChargeClass",
    "ChargeDescription",
    "ChargeFrequency",
    "ChargePeriodEnd",
    "ChargePeriodStart",
    "CommitmentDiscountCategory",
    "CommitmentDiscountId",
    "CommitmentDiscountName",
    "CommitmentDiscountQuantity",
    "CommitmentDiscountType",
    "CommitmentDiscountStatus",
    "CommitmentDiscountUnit",
    "ConsumedQuantity",
    "ConsumedUnit",
    "ContractedCost",
    "ContractedUnitPrice",
    "EffectiveCost",
    "InvoiceId",
    "InvoiceIssuerName",
    "ListCost",
    "ListUnitPrice",
    "PricingCategory",
    "PricingCurrency",
    "PricingCurrencyContractedUnitPrice",
    "PricingCurrencyEffectiveCost",
    "PricingCurrencyListUnitPrice",
    "PricingQuantity",
    "PricingUnit",
    "ProviderName",
    "PublisherName",
    "RegionId",
    "RegionName",
    "ResourceId",
    "ResourceName",
    "ResourceType",
    "ServiceCategory",
    "ServiceName",
    "ServiceSubcategory",
    "SkuId",
    "SkuPriceDetails",
    "SkuPriceId",
    "SkuMeter",
    "SubAccountId",
    "SubAccountName",
    "SubAccountType",
    "Tags",
    "x_Discounts",
    "x_Operation",
    "x_ServiceCode",
  ]
}

resource "aws_bcmdataexports_export" "daily_focus" {
  export {
    name = "InfracostDailyFocusExport"

    data_query {
      query_statement = format("SELECT %s FROM FOCUS_1_2_AWS", join(", ", local.focus_1_2_columns))
      table_configurations = {
        "FOCUS_1_2_AWS" = {
          "TIME_GRANULARITY" = "DAILY"
        }
      }
    }

    destination_configurations {
      s3_destination {
        s3_region = aws_s3_bucket.bcm_data_exports.region
        s3_bucket = aws_s3_bucket.bcm_data_exports.id
        s3_prefix = ""

        s3_output_configurations {
          overwrite   = "OVERWRITE_REPORT"
          format      = "PARQUET"
          compression = "PARQUET"
          output_type = "CUSTOM"
        }
      }
    }

    refresh_cadence {
      frequency = "SYNCHRONOUS"
    }
  }
}
