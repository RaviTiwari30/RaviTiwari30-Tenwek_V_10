<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="UserAuthorization.aspx.cs" Inherits="Design_EDP_UserAuthorization" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function RestrictDoubleEntry(btn) {
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');

        }
        $(function () {
            $('#ddlDepartment,#ddlEmployee').chosen();
        });
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>User Rights</b>
            <br />
            <asp:Label ID="lblMsg" Text="" CssClass="ItDoseLblError" runat="server"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDepartment" runat="server" ClientIDMode="Static" AutoPostBack="True" OnSelectedIndexChanged="ddlDepartment_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Employee
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlEmployee" runat="server" AutoPostBack="True" ClientIDMode="Static"
                                OnSelectedIndexChanged="ddlEmployee_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory ">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Authority Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:CheckBoxList ID="chkAuthority" runat="server" RepeatLayout="Table" RepeatColumns="3" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Can Give Discount" Value="IsDiscount"></asp:ListItem>
                                <asp:ListItem Text="Can Reject" Value="IsReject"></asp:ListItem>
                                <asp:ListItem Text="Can Edit Medical Item" Value="MedItemEdit"></asp:ListItem>
                                <asp:ListItem Text="Can Edit" Value="IsEdit"></asp:ListItem>
                                <asp:ListItem Text="Can Give Discount in Dummy Bill" Value="d_IsDiscount"></asp:ListItem>
                                <asp:ListItem Text="Can Reject in Dummy Bill" Value="d_IsReject"></asp:ListItem>
                                <asp:ListItem Text="Can Edit in Dummy Bill" Value="d_IsEdit"></asp:ListItem>
                                <asp:ListItem Text="Can Change &amp; Finalise Bill" Value="BillChange"></asp:ListItem>
                                <asp:ListItem Text="Can Lab Reject" Value="IsLabReject"></asp:ListItem>
                                <asp:ListItem Text="Can Open Finalise Bill" Value="IsFinalbillOpen"></asp:ListItem>
                                <asp:ListItem Text="Can Medicine Clearance" Value="IsMedClear"></asp:ListItem>
                                <asp:ListItem Value="EditQuot">Can Negotiate Supplier Quotation</asp:ListItem>
                                <asp:ListItem Value="PSetQuot">Can Lock Rate of Store Items</asp:ListItem>
                                <asp:ListItem Value="AppAmtAfterBill">Can Set Approval Amt After Bill Gen</asp:ListItem>
                                <asp:ListItem Value="PurchaseRequest">Can Approve/Reject Purchase Request</asp:ListItem>
                                <asp:ListItem Value="PurchaseOrder">Can Approve/Reject Purchase Order</asp:ListItem>
                                <asp:ListItem Value="Physical_Verification">Approve Adjustment</asp:ListItem>
                                <asp:ListItem Text="Can Give Discount after Bill" Value="IsDiscAfterBill"></asp:ListItem>
                                <asp:ListItem Text="Can Plan Discharge" Value="IsPlanDischarge"></asp:ListItem>
                                <asp:ListItem Text="Can Room Clearance" Value="IsRoomClearance"></asp:ListItem>
                                <asp:ListItem Text="Can Patient Clearance" Value="IsPatientClearance"></asp:ListItem>
                                <asp:ListItem Text="Can Nursing Clearance" Value="IsNurseClean"></asp:ListItem>
                                <asp:ListItem Text="Can Bill Freezed" Value="IsBillFreezed"></asp:ListItem>
                                <asp:ListItem Value="ChangeSellingPrice">Can Change Stock Selling Price</asp:ListItem>
                                <asp:ListItem Value="IsRefund">Can Refund</asp:ListItem>
                                <asp:ListItem Value="IsPostGRN">Can Post GRN</asp:ListItem>
                                <asp:ListItem Value="IsEditAfterPost">Can Edit GRN After Post</asp:ListItem>
                                <asp:ListItem Value="IsAllowedOriginalPrint">Can Print Original Receipt</asp:ListItem>
                                <asp:ListItem Value="IsCanSettleBatch">Can Settle Batch</asp:ListItem>
                                <asp:ListItem Value="CanViewRate">Can View Rate</asp:ListItem>
                                <asp:ListItem Value="CanViewVitalPopUp">Can Enter Vital (Appointment)</asp:ListItem>
                                <asp:ListItem Value="CanRefundAllAmount">Can Refund Full IPD Advance</asp:ListItem>
                                <asp:ListItem Value="CanShowCoPayment">Can Show Co-Payment in IPD Billing Frame</asp:ListItem>
                                <asp:ListItem Value="CanViewAllUserCollection">Can View All Users Collection Report</asp:ListItem>
                                <asp:ListItem Value="CanEditEMGBilling">Can Edit/Update Emergency Billing</asp:ListItem>
                                <asp:ListItem Value="CanRejectEMGBilling">Can Reject In Emergency Billing</asp:ListItem>
                                <asp:ListItem Value="CanViewRatesEMGBilling">Can View Rates In Emergency Billing</asp:ListItem>
                                <asp:ListItem Value="CanReleaseEMGPatient">Can Release Patient from Emergency</asp:ListItem>
                                <asp:ListItem Value="CanCloseEMGBilling">Can Close Emergency Bill</asp:ListItem>
                                <asp:ListItem Value="CanEditCloseEMGBilling">Can Edit Closed Emergency Bill</asp:ListItem>
                                <asp:ListItem Value="CanReceivePatient">Can Receive Patient in Ward</asp:ListItem>
                                <asp:ListItem Value="CanEditPurchaseOrder">Can Edit PO</asp:ListItem>
                                <asp:ListItem Value="CanEditMedicationRecord">Can Edit Medication Record</asp:ListItem>
                                <asp:ListItem Value="CanApproveDoctorAllocation">Can Approve Doctor Allocation</asp:ListItem>
                                <asp:ListItem Value="CanIndentMedicalItems">Can Indent Medical Store Items</asp:ListItem>
                                <asp:ListItem Value="CanIndentMedicalConsumables">Can Indent Medical Consumables</asp:ListItem>

                                 <asp:ListItem Value="CanChangePanel">Can Change Panel</asp:ListItem>
                                <asp:ListItem Value="CanEditBill">Can Edit Bill</asp:ListItem>
                                <asp:ListItem Value="CanChangeRelation">Can Change Relation</asp:ListItem>
                                <asp:ListItem Value="CanChangePaymentDetails">Can Receipt Edit</asp:ListItem>
                                <asp:ListItem Value="CanUploadPanelDocuments">Can Upload Panel Documents</asp:ListItem>

                                   <asp:ListItem Value="IsCanLab">Can Prescribe Labouratory Items </asp:ListItem>
                                 <asp:ListItem Value="IsCanRadio">Can Prescribe Radiology Items </asp:ListItem>
                                 <asp:ListItem Value="IsCanPro">Can Prescribe Procedures</asp:ListItem>
                                 <asp:ListItem Value="IsCanCon">Can Prescribe Doctor Consultations </asp:ListItem>
                                 <asp:ListItem Value="IsCanPack">Can Prescribe OPD Packages </asp:ListItem>
                                 <asp:ListItem Value="IsCanOther">Can Prescribe Other Charges</asp:ListItem>
                                <asp:ListItem Value="CanUpdateBillNarration">Can Update IPD Billing Narration</asp:ListItem>
                                <asp:ListItem Value="IsBlood">Can Prescribe Blood Bank</asp:ListItem>
<asp:ListItem Value="CanFilanisePersonnelForm">Can Filanise Personnel Form</asp:ListItem>
                                <asp:ListItem Value="CanRejectPersonnelForm">Can Reject Personnel Form</asp:ListItem>
                                <asp:ListItem Value="CanConductInterView">Can Conduct InterView</asp:ListItem>
                                <asp:ListItem Value="CanEnterInterViewRound">Can Enter InterView Round</asp:ListItem>
                                <asp:ListItem Value="CanAcknowledgeInterView">Can Acknowledge InterView</asp:ListItem>
                                <asp:ListItem Value="CanCloseInterViewProcess">Can Close InterView Process</asp:ListItem>
                                <asp:ListItem Value="CanEditCandidateMaster">Can Edit Candidate Master</asp:ListItem>
                                
                            </asp:CheckBoxList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <asp:Button ID="btnSave" Text="Save" runat="server" OnClick="btnSave_Click" OnClientClick="RestrictDoubleEntry(this);"
                    CssClass="ItDoseButton" />
            </div>
        </div>
    </div>
</asp:Content>
