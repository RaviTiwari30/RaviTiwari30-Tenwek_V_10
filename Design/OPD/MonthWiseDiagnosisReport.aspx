<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MonthWiseDiagnosisReport.aspx.cs" Inherits="Design_OPD_MonthWiseDiagnosisReport" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>

    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Month Wise Diagnosis Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Search Criteria
            </div>
            <div class="row">
                <div class="col-md-3">
                    Month :
                </div>
                <div class="col-md-5">

                    <asp:DropDownList runat="server" ID="ddlMonth">
                    </asp:DropDownList>
                </div>

                <div class="col-md-3">Year :</div>
                <div class="col-md-5">
                    <asp:DropDownList runat="server" ID="ddlYear">
                    </asp:DropDownList>
                </div>

                <div class="col-md-3">Ward :</div>
                <div class="col-md-5">
                    <asp:DropDownList runat="server" ID="ddlward">
                    </asp:DropDownList>
                </div>
            </div>

             <div class="row">
                <div class="col-md-3">
                    From Age(In Year) :
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtFromAge" runat="server" TextMode="Number" Text="0"></asp:TextBox>
                  
                </div>

                <div class="col-md-3">To Age(In Year) :</div>
                <div class="col-md-5">
                      <asp:TextBox ID="txtToAge" runat="server" TextMode="Number" Text="5"></asp:TextBox>
                  
                </div>
                  
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnReport" runat="server" Text="Report" OnClick="btnReport_Click" />
        </div>
    </div>
</asp:Content>
