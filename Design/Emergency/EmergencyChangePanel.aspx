<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EmergencyChangePanel.aspx.cs" Inherits="Design_Emergency_EmergencyChangePanel" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
      <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript">
        $(document).ready(function () {
            $bindUserRights(function () {
                $EMGNo = "<%=Request.QueryString["EMGNo"].ToString()%>";
                serverCall('../Emergency/Services/EmergencyBilling.asmx/getEmergencyPatientDetails', { EmergencyNo: $EMGNo }, function (response) {
                    if (jQuery.parseJSON(response) == null)
                        location.href = '../IPD/PatientBillMsg.aspx?msg=Patient Has Been Shifted To IPD.'
                    else {
                        EmergencyPatientDetails = jQuery.parseJSON(response)[0];
                        if (UserRights.CanEditCloseEMGBilling == "0") {
                            if (EmergencyPatientDetails.Status == 'OUT')
                                location.href = '../IPD/PatientBillMsg.aspx?msg=Patient Has Been Released.'
                            else if (EmergencyPatientDetails.BillNo != '')
                                location.href = '../IPD/PatientBillMsg.aspx?msg=Patient Bill Has Been Generated.'
                            else if (EmergencyPatientDetails.Status == "RFI")
                                location.href = '../IPD/PatientBillMsg.aspx?msg=Patient Has Been Released for IPD.'
                        }
                    }
                });
                $onInit();
            });
        });
    </script>
    <form id="form1" runat="server">
      <Ajax:ScriptManager ID="sc" runat="server" LoadScriptsBeforeUI="true" EnablePageMethods="true"></Ajax:ScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Emergency Bill Details</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-24">
                        <div class="col-md-3">
                            <label class="pull-left">Current Panel</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblcurrentpanel" ForeColor="Brown" Font-Bold="true" runat="server"></asp:Label>
                            <asp:Label ID="lblcurrentpanelid" ForeColor="RosyBrown" Font-Bold="true" runat="server" Visible="false"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Panel</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPanel" runat="server"></asp:DropDownList>
                        </div>
                    </div></div>
               
            </div>
            <div class="POuter_Box_Inventory">
             <div class="row" style="text-align:center">
                    <asp:Button ID="btnUpdatePanel" Text="Update Panel" runat="server" ClientIDMode="Static" OnClick="btnUpdatePanel_Click" />
                </div></div>
        </div>
    </form>
</body>
</html>
