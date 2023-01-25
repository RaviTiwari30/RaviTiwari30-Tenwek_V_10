<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ConsignmentStock.aspx.cs" Inherits="Design_Consignment_ConsignmentStock" Title="Untitled Page" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
 <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Consignment Stock Status Report</b><br />
                <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError"></asp:Label>

            </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Critaria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Departments
                            </label>
                             <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:DropDownList ID="ddlDpt" runat="server" CssClass="requiredField" ClientIDMode="Static" />
                            </div>
                        <div class="col-md-3">
                            <asp:Button ID="btnCloseStock" runat="server" Text="Report" OnClick="btnCloseStock_Click" CausesValidation="false" CssClass="ItDoseButton" Width="85px" />

                        </div>
                    </div>
                </div>
            </div>
        </div>
        
    </div>
</asp:Content>

