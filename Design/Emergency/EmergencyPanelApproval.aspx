<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EmergencyPanelApproval.aspx.cs" Inherits="Design_Emergency_EmergencyPanelApproval" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
    <%@ Register Src="~/Design/Controls/UCPanel.ascx" TagName="PanelDetailsControl" TagPrefix="UC3" %>
    <%@ Register Src="~/Design/Controls/wuc_EmergencyBillDetail.ascx" TagName="PatientIPDBillDetails" TagPrefix="UCPatientIPDBillDetails" %>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript">


        $(document).ready(function () {

            $('#lblApprovalAmount').text('Amount');
            $('#lblApprovalRemark').text('Remark');
            var patientPanelID = Number($('#lblPanelID').text());
            $panelControlInit(function () {
                $('#ddlPanelCompany option').each(function () {
                    var panelID = Number(this.value.split('#')[0]);
                    if (panelID == 1) {
                        $(this).remove();
                        $('#ddlParentPanel option[value=1]').remove()
                    }


                    if (patientPanelID == panelID)
                        $('#ddlPanelCompany').val(this.value).change();
                });
                $('#ddlPanelCompany').chosen('destroy').chosen();
            });
        });




        var getApprovalEmailToPanel = function (callback) {

            var patientID = $.trim($('#lblPatientID').text());
            var transactionID = $.trim($('#lblTransactionID').text());

            $getPanelDetails(function (panelDetails) {
                var data = {
                    transactionID: transactionID,
                    patientID: patientID,
                    panelID: panelDetails.panel.panelID,
                    approvalAmount: panelDetails.approvalAmount,
                    approvalRemark: panelDetails.approvalRemark,
                    policyNumber: panelDetails.policyNo,
                    policyCardNumber: panelDetails.cardNo,
                    policyExpiryDate: panelDetails.expireDate,
                    panelDocuments: panelDetails.panelDocuments,

                    nameOnCard: panelDetails.nameOnCard,
                    cardHolderRelation: panelDetails.cardHolderRelation,
                    ignorePolicy: panelDetails.ignorePolicy,
                    ignorePolicyReason: panelDetails.ignorePolicyReason,
                }
                callback(data);
            });
        }

        var sendApprovalEmailToPanel = function (callback) {
            getApprovalEmailToPanel(function (data) {
                modelConfirmation('Are you Sure ?', 'To Attach Cost Estimation .', 'Yes Continue', 'Cancel', function (res) {
                    data.attachCostEstimation = res;
                    serverCall('Services/EmergencyBilling.asmx/SendPanelApprovalEmail', { panelApprovalDetails: data }, function (response) {
                        var responseData = JSON.parse(response);
                        modelAlert(responseData.response, function () {
                            if (responseData.status)
                                window.location.reload();
                        });
                    });
                });
            });
        }




    </script>


    <form id="form1" runat="server">
        <cc1:ToolkitScriptManager runat="server" ID="scrScriptmanager"></cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <b> Panel Approval  Request</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
                </div>
            </div>

            <div class="POuter_Box_Inventory">

                <div class="Purchaseheader">
                    Patient Bill Details
                </div>
                <div class="col-md-24">
                   <UCPatientIPDBillDetails:PatientIPDBillDetails runat="server" ID="ass" />
                </div>

            </div>




            <div class="POuter_Box_Inventory">

                <div class="Purchaseheader">
                    Panel Details
                </div>
                <div class="col-md-24">
                    <UC3:PanelDetailsControl ID="admissionPanelDetails" runat="server" />
                </div>

            </div>


            <div class="POuter_Box_Inventory textCenter">
                <asp:Label runat="server" ID="lblPatientID" ClientIDMode="Static" Style="display: none"></asp:Label>
                <asp:Label runat="server" ID="lblTransactionID" ClientIDMode="Static" Style="display: none"></asp:Label>
                <asp:Label runat="server" ID="lblPanelID" ClientIDMode="Static" Style="display: none"></asp:Label>
                <asp:Label runat="server" ID="lblTID" ClientIDMode="Static" Style="display: none"></asp:Label>
                 <asp:Label runat="server" ID="lblLedgerTransactionNo" ClientIDMode="Static" Style="display: none"></asp:Label>
                <input type="button" value="Save" class=" save margin-top-on-btn" onclick="sendApprovalEmailToPanel(function () { })" />
            </div>





            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Panel Approval Details
                </div>
                <div class="row">
                    <div class="col-md-24">
                       <%-- <asp:GridView runat="server" ID="grvPanelApprovalDetails" HeaderStyle-CssClass="GridViewHeaderStyle" CssClass="GridViewStyle" Width="100%" ClientIDMode="Static">
                        </asp:GridView>
--%>



                        <asp:GridView runat="server" ID="grvPanelApprovalDetails" HeaderStyle-CssClass="GridViewHeaderStyle" CssClass="GridViewStyle" Width="100%" ClientIDMode="Static" AutoGenerateColumns="false" OnRowCommand="grvPanelApprovalDetails_RowCommand">
                            <Columns>
                                <asp:BoundField  DataField="Company_Name" HeaderText="Company Name" />
                                <asp:BoundField  DataField="PolicyNumber" HeaderText="Policy Number" />
                                <asp:BoundField  DataField="ApprovalAmount" HeaderText="Approval Amount" />
                                <asp:BoundField  DataField="ApprovalRemark" HeaderText="Approval Remark" />
                                <asp:BoundField  DataField="Approval_Send_On" HeaderText="Approval Send On" />
                                <asp:BoundField  DataField="Create_By" HeaderText="Create By" />
                                <asp:TemplateField HeaderText="Print">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imgPrint" runat="server" ImageUrl="~/Images/print.gif" AccessKey="p" CommandName="print" CommandArgument='<%# Eval("ID") %>' />
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="30px" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>

                    </div>
                </div>



            </div>




        </div>

    </form>
</body>
</html>
