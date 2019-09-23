view: taxi10billion {
  sql_table_name: `fh-bigquery.public_dump.taxi10billion`;;
  label: "NYC Taxi Data"

  dimension_group: dropoff {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.dropoff_datetime ;;
  }

  dimension: dropoff_latitude {
    hidden: yes
    type: number
    sql: ${TABLE}.dropoff_latitude ;;
  }

  dimension: dropoff_longitude {
    hidden: yes
    type: number
    sql: ${TABLE}.dropoff_longitude ;;
  }

  dimension: dropoff_location {
    type: location
    sql_latitude: ${dropoff_latitude} ;;
    sql_longitude: ${dropoff_longitude} ;;
  }

  dimension: extra {
    type: number
    sql: ${TABLE}.extra ;;
    value_format_name: usd
  }

  dimension: fare_amount {
    type: number
    sql: ${TABLE}.fare_amount ;;
    value_format_name: usd
  }

  dimension: imp_surcharge {
    type: number
    sql: ${TABLE}.imp_surcharge ;;
    value_format_name: usd
  }

  dimension: mta_tax {
    type: number
    sql: ${TABLE}.mta_tax ;;
    value_format_name: usd
  }

  dimension: passenger_count {
    type: number
    sql: ${TABLE}.passenger_count ;;
  }

  dimension: payment_type {
    type: string
    sql: ${TABLE}.payment_type ;;
  }

  dimension_group: pickup {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.pickup_datetime ;;
  }

  dimension: pickup_latitude {
    hidden: yes
    type: number
    sql: ${TABLE}.pickup_latitude ;;
  }

  dimension: pickup_longitude {
    hidden: yes
    type: number
    sql: ${TABLE}.pickup_longitude ;;
  }

  dimension: pickup_location {
    type: location
    sql_latitude: ${pickup_latitude};;
    sql_longitude: ${pickup_longitude} ;;
  }

  dimension: rate_code {
    type: string
    sql: ${TABLE}.rate_code ;;
  }

  dimension: store_and_fwd_flag {
    type: string
    sql: ${TABLE}.store_and_fwd_flag ;;
  }

  dimension: tip_amount {
    type: number
    sql: ${TABLE}.tip_amount ;;
  }

  dimension: tolls_amount {
    type: number
    sql: ${TABLE}.tolls_amount ;;
  }

  dimension: total_amount {
    type: number
    sql: ${TABLE}.total_amount ;;
  }

  dimension: trip_distance {
    type: number
    sql: ${TABLE}.trip_distance ;;
  }

  dimension: vendor_id {
    type: string
    sql: ${TABLE}.vendor_id ;;
  }

  ############## Derived dimensions ###############

  dimension: trip_duration {
    label: "Trip Duration (minutes)"
    type: number
    sql: TIMESTAMP_DIFF(${dropoff_raw},${pickup_raw},MINUTE) ;;
  }

  dimension: trip_duration_tier {
    label: "Trip Duration Tier (minutes)"
    type: tier
    tiers: [10,20,40,60]
    style: integer
    sql: ${trip_duration} ;;
  }

  set: drill_detail {
    fields: [vendor_id,pickup_time,dropoff_time,pickup_location,dropoff_location,trip_distance,total_amount]
  }

  ############## Measures ###############

  measure: count {
    label: "Number of Trips"
    type: count
    drill_fields: [drill_detail*]
    value_format_name: decimal_0
  }

  measure: average_fare {
    type: average
    sql: ${total_amount} ;;
    value_format_name: usd
    drill_fields: [drill_detail*]
  }

  measure: average_tip {
    type: average
    sql: ${tip_amount} ;;
    value_format_name: usd
    drill_fields: [drill_detail*]
  }

  measure: total_total_amount {
    type: sum
    sql: ${total_amount} ;;
    hidden: yes
  }

  measure: total_tip_amount {
    type: sum
    sql: ${tip_amount} ;;
    hidden: yes
  }

  measure: tip_percent_of_total_fare {
    type: number
    sql: ${total_tip_amount}/NULLIF(${total_total_amount},0) ;;
    value_format_name: percent_1
  }

  measure: average_number_of_passengers {
    type: average
    sql: ${passenger_count} ;;
    value_format_name: decimal_1
    drill_fields: [drill_detail*]
  }

  measure: average_duration {
    label: "Average Duration (minutes)"
    type: average
    sql: ${trip_duration} ;;
    value_format_name: decimal_1
    drill_fields: [drill_detail*]
  }

  measure: average_distance {
    label: "Average Distance (miles)"
    type: average
    sql: ${trip_distance} ;;
    value_format_name: decimal_1
    drill_fields: [drill_detail*]
  }

  measure: total_distance {
    label: "Total Distance (miles)"
    type: sum
    sql: ${trip_distance} ;;
    value_format_name: decimal_1
    drill_fields: [drill_detail*]
  }
}