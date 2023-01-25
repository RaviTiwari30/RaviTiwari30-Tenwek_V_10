<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MembershipCardSearch.aspx.cs" Inherits="Design_OPD_MemberShipCard_MembershipCardSearch" Title="Untitled Page" %>


<%@ Register Src="~/Design/Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="../../../Styles/grid24.css" rel="stylesheet" />
    <div id="Pbody_box_inventory">
        <div class="Outer_Box_Inventory" style="width: 99.7%">
            <div  style="text-align: center;">
                <strong><span style="font-size: 12pt"><span style="font-size: 11pt">Membership Card Search<br />
                </span>
                    <asp:Label ID="lblmsg" runat="server" Font-Bold="True" Font-Size="9pt" ForeColor="Red"></asp:Label></span></strong>
            </div>
        </div>
        <div class="Outer_Box_Inventory" style="width: 99.7%">
            <div class="Purchaseheader">
                Searching Criteria
         &nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Card Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlCardType" runat="server" CssClass="inputbox">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Card Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlCardStatus" runat="server">
                            <asp:ListItem></asp:ListItem>
                            <asp:ListItem>Under Process</asp:ListItem>
                            <asp:ListItem>Dispatched</asp:ListItem>
                        </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Card No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCardNo" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                          
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <uc1:EntryDate ID="txtFromDate" runat="server" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <uc1:EntryDate ID="txtToDate" runat="server" />
                        </div>
                        
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                             <asp:CheckBox ID="chkExpiry" runat="server" />Expiry From
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <uc1:EntryDate ID="txtExpiryFrom" runat="server" />
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">
                                Expiry To
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <uc1:EntryDate ID="txtExpiryTo" runat="server" />
                        </div>
                            <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div class="row"></div>
        </div>
        <div class="Outer_Box_Inventory" style="width: 99.7%; text-align: center">
            <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" CssClass="ItDoseButton" Text="Search" />
        </div>
    </div>
</asp:Content>

