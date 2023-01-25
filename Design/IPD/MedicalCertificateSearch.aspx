<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MedicalCertificateSearch.aspx.cs"
    Inherits="Design_EDP_MedicalCertificateSearch" MasterPageFile="~/DefaultHome.master" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Src="../Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="content1" runat="server">
       <Ajax:ScriptManager ID="sc" runat="server">        </Ajax:ScriptManager>
    <script type="text/javascript" language="javascript" src="../../JavaScript/Search.js"></script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align:center">
            <b>Medical Certificate Search</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>
              <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        UHID
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtmrno" runat="server" ToolTip="Enter UHID" TabIndex="1"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        IPD No.
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtIPNo" runat="server" ToolTip="Enter Patient IPD No." TabIndex="2" MaxLength="10"></asp:TextBox>
                    
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Mobile 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtmobileno" runat="server" ToolTip="Enter Patient Name" TabIndex="3"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Certificate No. 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtipdno" runat="server" ToolTip="Enter Mobile No." TabIndex="4" MaxLength="10"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        From Date 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" ClientIDMode="Static" TabIndex="13" ></asp:TextBox>
                    <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">

                    <label class="pull-left">
                        To Date 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="ucToDate" runat="server" ReadOnly="true"  ClientIDMode="Static" TabIndex="14" ToolTip="Click To Select To Date"></asp:TextBox>
                    <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
            </div>
       
        </div>
        <div class="POuter_Box_Inventory" style="text-align:center">
                    &nbsp;<asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Height="25px"
                        TabIndex="7" Text="Search" Width="71px" OnClick="btnSearch_Click" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Patient Details Found
            </div>
            <div style="overflow: auto; padding: 3px; width: 100%; max-height: 100px;">
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    OnRowCommand="GridView1_RowCommand" Width="100%">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:BoundField DataField="ID" HeaderText="Certificate No.">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="PName" HeaderText="PatientName">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Mobile" HeaderText="Mobile">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="PatientID" HeaderText="UHID">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Address" HeaderText="Address">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="350px" />
                        </asp:BoundField>
                        <%--  <asp:TemplateField HeaderText="Select">
                                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                            <ItemTemplate>
                                                <asp:ImageButton ID="imbSelect" ToolTip="Select" runat="server" ImageUrl="../Purchase/Image/Post.gif"
                                                    CausesValidation="false" CommandArgument='<%# Eval("PatientID")%>' CommandName="Select" />
                                            </ItemTemplate>
                                        </asp:TemplateField>--%>
                        <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="false" CommandArgument='<%#Eval("id") %>'
                                    CommandName="AEdit" ImageUrl="~/Images/edit.png" />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Print">
                            <ItemTemplate>
                                <asp:Label ID="lblAppointmentLetterType" Visible="false" runat="server"></asp:Label>
                                <asp:ImageButton ID="imbPrint" runat="server" CausesValidation="false" CommandArgument='<%#Eval("id") %>'
                                    CommandName="RPrint" ImageUrl="~/Images/Print.gif" />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="50px" HorizontalAlign="Center" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="divptdetail" runat="server" visible="false">
            <div class="Purchaseheader">
                Patient Details:
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        UHID 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtmr" runat="server" Enabled="false"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Name 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtptname" runat="server" Enabled="false"></asp:TextBox>
                    <asp:Label ID="lblcerid" runat="server" Style="display: none"></asp:Label>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Age/Sex
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtage" runat="server" CssClass="ItDoseTextinputText" Enabled="false" Width="74px"></asp:TextBox>&nbsp;
                            <asp:TextBox ID="txtgender" runat="server" Enabled="false" Width="165px"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Relationship
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtrelation" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        From Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtfrmdate" runat="server" ToolTip="Click To Select From Date"  ClientIDMode="Static" TabIndex="13"></asp:TextBox>
                    <cc1:CalendarExtender ID="cc3" runat="server" TargetControlID="txtfrmdate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        To Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtToDate" runat="server" ToolTip="Click To Select To Date" ClientIDMode="Static" TabIndex="13"></asp:TextBox>
                    <cc1:CalendarExtender ID="cc4" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Address
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Height="52px"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Diagnosis
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtdiagnosis" runat="server" TextMode="MultiLine" Height="52px"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Remarks
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Height="57px"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Doctor
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtdoctorname" runat="server" Enabled="false"></asp:TextBox>
                </div>
                <div class="col-md-3" style="display: none">
                    <label class="pull-left">
                        Signature
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5" style="display: none">
                    <asp:TextBox ID="txtdrsign" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-3" style="display: none">
                    <label class="pull-left">
                        Department
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5" style="display: none">
                    <asp:TextBox ID="txtdocdept" runat="server"></asp:TextBox>
                </div>
            </div>
       
            <div style="text-align: center">
                <asp:Button ID="txtsave" runat="server" Text="Save" OnClick="txtsave_Click" />
            </div>
        </div>
    </div>
</asp:Content>
