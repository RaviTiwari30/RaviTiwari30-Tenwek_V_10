<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="Map_Employee_Payroll.aspx.cs" Inherits="Design_Payroll_Map_Employee_Payroll"
    Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" align="center">
            <b>Map Employee Payroll</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Detail
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-12">
                            <b class="pull-left">HIS Employee</b>
                        </div>
                        <div class="col-md-12">
                            <b class="pull-left">
                                Payroll Employee
                            </b>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <asp:ListBox ID="lstAvailAbleRight" runat="server" Height="500px" SelectionMode="Multiple"
                                CssClass="ItDoseListbox"></asp:ListBox>
                        </div>
                    <div class="col-md-12">
                        <asp:ListBox ID="lstRight" runat="server" SelectionMode="Multiple" Height="500px"
                            CssClass="ItDoseListbox"></asp:ListBox>
                    </div>
                </div>
            </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" align="center">
            <asp:Button ID="btnMapEmployee" runat="server" CssClass="ItDoseButton" Width="140px"
                Text="Map Employee" OnClick="btnMapEmployee_Click" Style="margin-top:7px;" />
        </div>
    </div>
</asp:Content>
