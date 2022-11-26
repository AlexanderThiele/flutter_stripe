import 'package:stripe_js/stripe_api.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_intent.freezed.dart';
part 'payment_intent.g.dart';

/// Reason for cancellation of this PaymentIntent,
/// either user-provided (duplicate, fraudulent, requested_by_customer, or
/// abandoned) or generated by Stripe internally (failed_invoice, void_invoice,
/// or automatic).
@JsonEnum(fieldRename: FieldRename.snake)
enum PaymentIntentCancellationReason {
  duplicate,
  fraudulent,
  requestedByCustomer,
  abandoned,
  failedInvoice,
  voidInvoice,
  automatic,
}

/// Controls when the funds will be captured from the customer’s account.
enum PaymentIntentCaptureMethod {
  /// (Default) Stripe automatically captures funds when the
  /// customer authorizes the payment.
  automatic,

  /// Place a hold on the funds when the customer authorizes the payment,
  /// but don’t capture the funds until later.
  /// (Not all payment methods support this.)
  manual,
}

enum PaymentIntentConfirmationMethod {
  /// (Default) PaymentIntent can be confirmed using a publishable key.
  /// After next_actions are handled, no additional confirmation is required
  /// to complete the payment.
  automatic,

  /// All payment attempts must be made using a secret key.
  /// The PaymentIntent returns to the requires_confirmation
  /// state after handling next_actions, and requires your server to
  /// initiate each payment attempt with an explicit confirmation.
  manual,
}

enum PaymentIntentSetupFutureUsage {
  /// Use on_session if you intend to only reuse the payment method
  /// when your customer is present in your checkout flow.
  @JsonValue('on_session')
  onSession,

  /// Use off_session if your customer may or may not be present in your checkout flow.
  @JsonValue('off_session')
  offSession,
}

/// A PaymentIntent guides you through the process of collecting a payment
/// from your customer.
/// We recommend that you create exactly one PaymentIntent for each order or
/// customer session in your system.
///
/// You can reference the PaymentIntent later to see the history of payment
/// attempts for a particular session.
/// A PaymentIntent transitions through multiple statuses throughout
/// its lifetime as it interfaces with Stripe.js to perform authentication
/// flows and ultimately creates at most one successful charge.
///
/// https://stripe.com/docs/api/payment_intents
@freezed
class PaymentIntent with _$PaymentIntent {
  const factory PaymentIntent({
    /// Unique identifier for the object.
    required String id,

    /// String representing the object’s type.
    /// Objects of the same type share the same value.
    /// Value is "payment_intent".
    @Default("payment_intent") String object,

    /// Amount intended to be collected by this PaymentIntent.
    /// A positive integer representing how much to charge in the
    /// smallest currency unit (e.g., 100 cents to charge $1.00 or 100 to
    /// charge ¥100, a zero-decimal currency).
    /// The minimum amount is $0.50 US or equivalent in charge currency.
    /// The amount value supports up to eight digits
    /// (e.g., a value of 99999999 for a USD charge of $999,999.99).
    required int amount,

    /// The amount that can be captured with from this PaymentIntent (in cents).
    @JsonKey(name: "amount_capturable") int? amountCapturable,

    /// Details about items included in the amount
    @JsonKey(name: "amount_details") PaymentIntentAmountDetails? amountDetails,

    /// The amount that was collected from this PaymentIntent (in cents).
    @JsonKey(name: "amount_received") int? amountReceived,

    /// CONNECT ONLY
    /// ID of the Connect application that created the PaymentIntent.
    String? application,

    /// CONNECT ONLY
    /// The amount of the application fee (if any) that will be requested to
    /// be applied to the payment and transferred to the application owner’s
    /// Stripe account. The amount of the application fee collected will be
    /// capped at the total payment amount.
    /// For more information, see the PaymentIntents use
    /// case for connected accounts..
    @JsonKey(name: "application_fee_amount") int? applicationFeeAmount,

    /// Settings to configure compatible payment methods from the
    /// Stripe Dashboard
    @JsonKey(name: "automatic_payment_methods")
        PaymentIntentAutomaticPaymentMethods? automaticPaymentMethods,

    /// Populated when status is canceled, this is the time at which the
    /// PaymentIntent was canceled. Measured in seconds since the Unix epoch.
    @JsonKey(name: "canceled_at") int? canceledAt,

    /// Reason for cancellation of this PaymentIntent,
    /// either user-provided
    /// (duplicate, fraudulent, requested_by_customer, or abandoned) or
    /// generated by Stripe internally
    /// (failed_invoice, void_invoice, or automatic).
    @JsonKey(name: "cancellation_reason")
        PaymentIntentCancellationReason? cancellationReason,

    /// The client secret of this PaymentIntent. Used for client-side retrieval
    /// using a publishable key.
    /// The client secret can be used to complete a payment from your frontend.
    /// It should not be stored, logged, or exposed to anyone other than the
    /// customer. Make sure that you have TLS enabled on any page that includes
    /// the client secret.
    ///
    /// Refer to our docs to accept a payment and learn about how `client_secret`
    /// should be handled.
    @JsonKey(name: "client_secret") required String clientSecret,

    /// Controls when the funds will be captured from the customer’s account.
    @JsonKey(name: "capture_method")
    @Default(PaymentIntentCaptureMethod.automatic)
        PaymentIntentCaptureMethod captureMethod,
    @JsonKey(name: "confirmation_method")
    @Default(PaymentIntentConfirmationMethod.automatic)
        PaymentIntentConfirmationMethod confirmationMethod,

    /// Time at which the object was created. Measured in seconds since the
    /// Unix epoch.
    int? created,

    /// Three-letter ISO currency code, in lowercase. Must be a supported
    /// currency.
    required String currency,

    /// ID of the Customer this PaymentIntent belongs to, if one exists.
    /// Payment methods attached to other Customers cannot be used with this
    /// PaymentIntent.
    ///
    /// If present in combination with setup_future_usage,
    /// this PaymentIntent’s payment method will be attached to the
    /// Customer after the PaymentIntent has been confirmed and any
    /// required actions from the user are complete.
    String? customer,

    /// An arbitrary string attached to the object.
    /// Often useful for displaying to users.
    String? description,

    /// ID of the invoice that created this PaymentIntent, if it exists.
    String? invoice,

    /// The payment error encountered in the previous PaymentIntent confirmation.
    /// It will be cleared if the PaymentIntent is later updated for any reason.
    @JsonKey(name: "last_payment_error") StripeError? lastPaymentError,

    /// The latest charge created by this payment intent.
    @JsonKey(name: "latest_charge") String? latestCharge,

    /// Has the value true if the object exists in live mode or the
    /// value false if the object exists in test mode.
    required bool livemode,

    /// Set of key-value pairs that you can attach to an object.
    /// This can be useful for storing additional information about the
    /// object in a structured format.
    @Default({}) Map<String, dynamic> metadata,

    /// If present, this property tells you what actions you need to
    /// take in order for your customer to fulfill a payment using the
    /// provided source.
    @JsonKey(name: "next_action") dynamic nextAction,

    /// CONNECT ONLY
    /// The account (if any) for which the funds of the PaymentIntent are
    /// intended. See the PaymentIntents use case for connected accounts
    /// for details.
    @JsonKey(name: "on_behalf_of") String? onBehalfOf,

    /// ID of the payment method used in this PaymentIntent.
    @JsonKey(name: "payment_method") String? paymentMethod,

    /// Payment-method-specific configuration for this PaymentIntent.
    @Default({})
    @JsonKey(name: "payment_method_options")
        Map<dynamic, dynamic> paymentMethodOptions,

    /// The list of payment method types (e.g. card) that this PaymentIntent
    /// is allowed to use.
    @JsonKey(name: "payment_method_types")
    @Default([])
        List<PaymentMethodType> paymentMethodTypes,

    /// If present, this property tells you about the processing state of the payment.
    dynamic processing,

    /// Email address that the receipt for the resulting payment will be sent to.
    /// If receipt_email is specified for a payment in live mode, a receipt
    /// will be sent regardless of your email settings.
    @JsonKey(name: "receipt_email") String? receiptEmail,

    // ID of the review associated with this PaymentIntent, if any.
    String? review,

    /// Indicates that you intend to make future payments with this
    /// PaymentIntent’s payment method.
    /// Providing this parameter will attach the payment method to the
    /// PaymentIntent’s Customer, if present, after the PaymentIntent is
    /// confirmed and any required actions from the user are complete. I
    /// If no Customer was provided, the payment method can still be attached to
    /// a Customer after the transaction completes.
    /// When processing card payments, Stripe also uses setup_future_usage
    /// to dynamically optimize your payment flow and comply with regional
    /// legislation and network rules, such as SCA.
    @JsonKey(name: "setup_future_usage")
        PaymentIntentSetupFutureUsage? setupFutureUsage,

    /// Shipping information for this PaymentIntent.
    ShippingDetails? shipping,

    /// For non-card charges, you can use this value as the complete
    /// description that appears on your customers’ statements.
    /// Must contain at least one letter, maximum 22 characters.
    @JsonKey(name: "statement_descriptor") String? statementDescriptor,

    /// Provides information about a card payment that customers see on
    /// their statements.
    /// Concatenated with the prefix (shortened descriptor) or statement
    /// descriptor that’s set on the account to form the complete statement
    /// descriptor. Maximum 22 characters for the concatenated descriptor.
    @JsonKey(name: "statement_descriptor_suffix")
        String? statementDescriptorSuffix,

    /// Status of this PaymentIntent, one of requires_payment_method,
    /// requires_confirmation, requires_action, processing, requires_capture,
    /// canceled, or succeeded.
    required PaymentIntentsStatus status,

    /// CONNECT ONLY
    /// The data with which to automatically create a Transfer when the payment
    /// is finalized. See the PaymentIntents use case for connected
    /// accounts for details.
    @JsonKey(name: "transfer_data") dynamic transferData,

    /// CONNECT ONLY
    /// A string that identifies the resulting payment as part of a group.
    /// See the PaymentIntents use case for connected accounts for details.
    @JsonKey(name: "transfer_group") dynamic transferGroup,
  }) = _PaymentIntent;

  factory PaymentIntent.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntentFromJson(json);
}

@freezed
class PaymentIntentAmountDetails with _$PaymentIntentAmountDetails {
  const factory PaymentIntentAmountDetails({
    /// Details about items included in the amount
    PaymentIntentTip? tip,
  }) = _PaymentIntentAmountDetails;

  factory PaymentIntentAmountDetails.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntentAmountDetailsFromJson(json);
}

@freezed
class PaymentIntentTip with _$PaymentIntentTip {
  const factory PaymentIntentTip({
    /// Portion of the amount that corresponds to a tip.
    int? amount,
  }) = _PaymentIntentTip;

  factory PaymentIntentTip.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntentTipFromJson(json);
}

@freezed
class PaymentIntentAutomaticPaymentMethods
    with _$PaymentIntentAutomaticPaymentMethods {
  const factory PaymentIntentAutomaticPaymentMethods({
    /// Automatically calculates compatible payment methods
    required bool? enabled,
  }) = _PaymentIntentAutomaticPaymentMethods;

  factory PaymentIntentAutomaticPaymentMethods.fromJson(
          Map<String, dynamic> json) =>
      _$PaymentIntentAutomaticPaymentMethodsFromJson(json);
}
