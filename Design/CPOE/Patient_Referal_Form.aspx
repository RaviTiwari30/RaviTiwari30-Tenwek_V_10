<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Patient_Referal_Form.aspx.cs" Inherits="Design_CPOE_Patient_Referal_Form" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>

    <style type="text/css">
        .auto-style1 {
            width: 458px;
        }

        .auto-style2 {
            width: 15%;
        }
    </style>

</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>

    <script src="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.js"></script>
    <link href="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.css" rel="stylesheet" />
    

    <form id="form1" runat="server">

        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Refferal Letter</b>
                <br />
                <asp:TextBox ID="txtHash" CssClass="txtHash" runat="server" ClientIDMode="Static" Style="display: none"></asp:TextBox>
                <span id="spnErrorMsg" class="ItDoseLblError"></span>
                <span id="spnPanelID" style="display: none" runat="server" clientidmode="Static"></span>
                <span id="spnTransactionID" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnPatientID" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnIPD_CaseTypeID" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnRoomID" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnCanIndentMedicalItems" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnCanIndentMedicalConsumables" runat="server" clientidmode="Static" style="display: none"></span>
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
 
            <div class="POuter_Box_Inventory">
                 <div class="row"> 
                    <div class="col-md-22">
                        <asp:TextBox ID="txtRefMsg" runat="server" TextMode="MultiLine" Height="200px" CssClass="required"></asp:TextBox>
                     </div> 
                </div>
                <div class="row">
                     <div class="col-md-5">
                         Name Of the Hospital refered To : 
                     </div> 
                    <div class="col-md-10">
                        <asp:TextBox ID="txtHosRefereTo" runat="server" CssClass="required"></asp:TextBox>
                     </div> 
                </div>
                <div class="row">
                    <div class="col-md-5">
                       Referral Consultants : 
                     </div> 
                    <div class="col-md-10">
                        <asp:TextBox ID="txtReferralConsultants" runat="server" CssClass="required"></asp:TextBox>
                     </div> 
                </div>
                <div class="row">
                     <div class="col-md-5">
                        Reason for Referral : 
                     </div> 
                    <div class="col-md-10">
                        <asp:TextBox ID="txtReasonforReferral" runat="server" TextMode="MultiLine"></asp:TextBox>
                     </div> 
                </div>
                 <div class="row">
                     <div class="col-md-5">
                         Referring Consultant :
                     </div> 
                    <div class="col-md-10">
                        <asp:TextBox ID="txtReferringConsultant" runat="server" CssClass="required"></asp:TextBox>
                     </div> 
                </div>
            </div>

            <div style="text-align: center;" class="POuter_Box_Inventory" id="divSave">
                <asp:Button ID="btnSave" runat="server" Text="Save" style="margin-top:2px" OnClick="btnSave_Click" />

                 <asp:Button ID="btnPrint" runat="server" Text="Print" style="margin-top:2px" OnClick="btnPrint_Click" Visible="false" />
                 <asp:Button ID="btnUpdate" runat="server" Text="Update" style="margin-top:2px" OnClick="btnUpdate_Click" Visible="false" />

            </div>
             


        </div>

        </form>

        <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css">
        <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>


        <script type="text/javascript">

       
         
        </script>
</body>
</html>


