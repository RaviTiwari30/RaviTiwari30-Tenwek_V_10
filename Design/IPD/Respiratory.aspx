<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Respiratory.aspx.cs" Inherits="Design_IPD_Respiratory" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>

    <script type="text/javascript">
        if ($.browser.msie) {
            $(document).on("keydown", function (e) {
                var doPrevent;
                if (e.keyCode == 8) {
                    var d = e.srcElement || e.target;
                    if (d.tagName.toUpperCase() == 'INPUT' || d.tagName.toUpperCase() == 'TEXTAREA') {
                        doPrevent = d.readOnly
                            || d.disabled;
                    }
                    else
                        doPrevent = true;
                }
                else
                    doPrevent = false;
                if (doPrevent) {
                    e.preventDefault();
                }
            });
        }


    </script>
    
</head>

<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <form id="form1" runat="server">
        <script type="text/javascript">
            $(document).ready(function () {

            });
        </script>
        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Respiratory System</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Respiratory System
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtDate" CssClass="requiredField" runat="server" ReadOnly="true"></asp:TextBox>
                                <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Time
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtTime" runat="server"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTime"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                            </div>
                        </div>
                        <div class="row Purchaseheader">
                             Settings
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Mode
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtMode" runat="server"></asp:TextBox>
                            </div>                          
                            <div class="col-md-3">
                                <label class="pull-left">
                                    FiO2
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtFio2" runat="server"></asp:TextBox>
                            </div> 
                            <div class="col-md-3">
                                <label class="pull-left">
                                    PEEP
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtPeep" runat="server"></asp:TextBox>
                            </div>
                         </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Rate
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtRate" runat="server"></asp:TextBox>
                            </div> 
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Tidal Vol.(or Tlow)
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtTidal" runat="server"></asp:TextBox>
                            </div>                       
                            <div class="col-md-6">
                                <label class="pull-left">
                                    Pressure Control above PEEP (or PHigh)
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-2">
                                <asp:TextBox ID="txtPressure" runat="server"></asp:TextBox>
                            </div>                         
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Pressure Support
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtsupport" runat="server"></asp:TextBox>
                            </div>                       
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Insp Time (or Thigh)
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtInsp" runat="server"></asp:TextBox>                               
                            </div>
                       </div>
                      <div class="row Purchaseheader">
                             Patient
                        </div>
                       <div class="row">                                                
                            <div class="col-md-3">
                                <label class="pull-left">
                                    SpO2
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtSpO2" runat="server"></asp:TextBox>
                            </div>
                           <div class="col-md-3">
                                <label class="pull-left">
                                   Rate
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                 <asp:TextBox ID="txtPRate" runat="server"></asp:TextBox>                               
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Mandatory Tidal Vol. 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtMandatory" runat="server"></asp:TextBox>
                            </div> 
                        </div>
                        <div class="row">                            
                               <div class="col-md-3">
                                <label class="pull-left">
                                    Spont Tidal Volume
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtSpont" runat="server"></asp:TextBox>
                            </div>
                           <div class="col-md-3">
                                <label class="pull-left">
                                   Minute Volume
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                 <asp:TextBox ID="txtMinuteVol" runat="server"></asp:TextBox>                               
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Peak Pressure
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtPeak" runat="server"></asp:TextBox>
                            </div>                 
                        </div>
                        <div class="row">                            
                               <div class="col-md-3">
                                <label class="pull-left">
                                    Platea Pressure
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtPlatea" runat="server"></asp:TextBox>
                            </div>
                           <div class="col-md-3">
                                <label class="pull-left">
                                   Suction information
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                 <asp:TextBox ID="txtSuction" runat="server"></asp:TextBox>                               
                            </div>                                            
                        </div>
                        <div class="row Purchaseheader">
                             ABG
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    ABG 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                     <asp:DropDownList ID="ddlABG" ClientIDMode="Static" runat="server">
                                        <asp:ListItem Selected="True" Value="0">Select</asp:ListItem>
                                        <asp:ListItem Value="Arterial">Arterial</asp:ListItem>
                                        <asp:ListItem Value="Venous">Venous</asp:ListItem>
                                        <asp:ListItem Value="Capillary">Capillary</asp:ListItem>                                                                
                                    </asp:DropDownList>
                            </div>  
                             <div class="col-md-3">
                                <label class="pull-left">
                                    pH 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtpH" runat="server"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    PCO2 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtPCO2" runat="server"></asp:TextBox>
                            </div> 
                         </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    HCO3 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtHCO3" runat="server"></asp:TextBox>
                            </div>  
                             <div class="col-md-3">
                                <label class="pull-left">
                                    BE
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtBE" runat="server"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    PO2 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtPO2" runat="server"></asp:TextBox>
                            </div> 
                         </div> 
                         <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Comments
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtComments" runat="server"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label>
                                <asp:Label ID="lblCreatedDate" runat="server" Visible="false"></asp:Label>
                            </div>
                        </div>
                   </div>
                </div>
              </div>
             <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Button ID="Btnsave" runat="server" OnClick="btnSave_Click" Text="save" CssClass="ItDoseButton" />
                <asp:Button ID="btnUpdate" runat="server" Text="Update" Visible="false" CssClass="ItDoseButton" TabIndex="69" OnClick="btnUpdate_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="ItDoseButton" TabIndex="69" Visible="false" OnClick="btnCancel_Click" />
               <%-- <asp:Button ID="btnPrint" runat="server" Text="Print" CssClass="ItDoseButton" TabIndex="69" OnClick="btnPrint_Click" />--%>
            </div>
            </div>           

            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="height: 19px;">
                    Results
                </div>
                <div style="text-align: center;">
                    <asp:GridView ID="grdNursing" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowDataBound="grdNursing_RowDataBound" OnRowCommand="grdNursing_RowCommand" OnPageIndexChanging="OnPageIndexChanging" AllowPaging="true" PagerSettings-PageButtonCount="5">
                        <Columns>
                            <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px"></HeaderStyle>
                                <ItemStyle CssClass="GridViewItemStyle" Width="20px"></ItemStyle>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Date">
                                <ItemTemplate>
                                    <asp:Label ID="lbldate" runat="server" Text='<%#Eval("Date") %>' ToolTip="Date"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Time">
                                <ItemTemplate>
                                    <asp:Label ID="lblTime" runat="server" Text='<%#Eval("Time") %>' ToolTip="Time" ></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Mode">
                                <ItemTemplate>
                                    <asp:Label ID="lblMode" runat="server" Text='<%#Eval("Mode") %>' ToolTip="Mode" ></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="FiO2">
                                <ItemTemplate>
                                    <asp:Label ID="lblFiO2" runat="server" Text='<%#Eval("FiO2") %>' ToolTip="FiO2" ></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="PEEP">
                                <ItemTemplate>
                                    <asp:Label ID="lblPeep" runat="server" Text='<%#Eval("Peep") %>' ToolTip="PEEP" ></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Rate">
                                <ItemTemplate>
                                    <asp:Label ID="lblRate" runat="server" Text='<%#Eval("Rate") %>' ToolTip="Rate" ></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Tidal Vol.">
                                <ItemTemplate>
                                    <asp:Label ID="lblTidal" runat="server" Text='<%#Eval("Tidal") %>' ToolTip="Tidal Vol." ></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField>
                                 <HeaderTemplate>
                                    <asp:Label ID="HdrPressure" ToolTip="Pressure Control above PEEP (or PHigh)" runat="server" Text="Pressure"></asp:Label>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblPressure" runat="server" Text='<%#Eval("Pressure") %>' ToolTip="Pressure Control above PEEP"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField>
                                 <HeaderTemplate>
                                    <asp:Label ID="HdrPSupport" ToolTip="Pressure Support" runat="server" Text="PSupport"></asp:Label>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblsupport" runat="server" Text='<%#Eval("Support") %>' ToolTip="Pressure Support"  ></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField >
                                <HeaderTemplate>
                                    <asp:Label ID="HdrInsp" ToolTip="Insp Time (or Thigh)" runat="server" Text="Insp"></asp:Label>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblInsp" runat="server" Text='<%#Eval("Insp") %>' ToolTip="Insp Time (or Thigh)" ></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="SpO2">
                                <ItemTemplate>
                                    <asp:Label ID="lblSpO2" runat="server" Text='<%#Eval("SpO2") %>' ToolTip="SpO2"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="PRate">
                                <ItemTemplate>
                                    <asp:Label ID="lblPRate" runat="server" Text='<%#Eval("PRate") %>' ToolTip="Rate"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField>
                                 <HeaderTemplate>
                                    <asp:Label ID="HdrMandatory" ToolTip="Mandatory Tidal Vol." runat="server" Text="Mandatory"></asp:Label>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblMandatory" runat="server" Text='<%#Eval("Mandatory") %>' ToolTip="Mandatory Tidal Vol."></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField >
                                <HeaderTemplate>
                                    <asp:Label ID="HdrSpont" ToolTip="Spont Tidal Vol." runat="server" Text="Spont"></asp:Label>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblSpont" runat="server" Text='<%#Eval("Spont") %>' ToolTip="Spont Tidal Vol."></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="MinuteVol">
                                <ItemTemplate>
                                    <asp:Label ID="lblMinuteVol" runat="server" Text='<%#Eval("MinuteVol") %>' ToolTip="Minute Vol."></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:Label ID="HdrPeak" ToolTip="Peak Pressure" runat="server" Text="Peak"></asp:Label>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblPeak" runat="server" Text='<%#Eval("Peak") %>' ToolTip="Peak Pressure"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:Label ID="HdrPlatea" ToolTip="Platea Pressure" runat="server" Text="Platea"></asp:Label>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblPlatea" runat="server" Text='<%#Eval("Platea") %>' ToolTip="Platea Pressure"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                             <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:Label ID="HdrSuction" ToolTip="Suction information" runat="server" Text="Suction"></asp:Label>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblSuction" runat="server" Text='<%#Eval("Suction") %>' ToolTip="Suction information"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                              <asp:TemplateField HeaderText="ABG">
                                <ItemTemplate>
                                    <asp:Label ID="lblABG" runat="server" Text='<%#Eval("ABG") %>' ToolTip="ABG"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                              <asp:TemplateField HeaderText="pH">
                                <ItemTemplate>
                                    <asp:Label ID="lblpH" runat="server" Text='<%#Eval("pH") %>' ToolTip="pH"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                              <asp:TemplateField HeaderText="PCO2">
                                <ItemTemplate>
                                    <asp:Label ID="lblPCO2" runat="server" Text='<%#Eval("PCO2") %>' ToolTip="PCO2"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                              <asp:TemplateField HeaderText="HCO3">
                                <ItemTemplate>
                                    <asp:Label ID="lblHCO3" runat="server" Text='<%#Eval("HCO3") %>' ToolTip="HCO3"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                              <asp:TemplateField HeaderText="BE">
                                <ItemTemplate>
                                    <asp:Label ID="lblBE" runat="server" Text='<%#Eval("BE") %>' ToolTip="BE"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                              <asp:TemplateField HeaderText="PO2">
                                <ItemTemplate>
                                    <asp:Label ID="lblPO2" runat="server" Text='<%#Eval("PO2") %>' ToolTip="PO2"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Comments">
                                <ItemTemplate>
                                    <asp:Label ID="lblComments" runat="server" Text='<%#Eval("Comments") %>' ToolTip="Comments"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Entry By">
                                <ItemTemplate>
                                    <asp:Label ID="lblCreatedBy" runat="server" Text='<%#Eval("Username") %>'></asp:Label>
                                    <asp:Label ID="lblCreatedID" runat="server" Text='<%#Eval("CreatedBy") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Edit">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                    <asp:Label ID="lblUserID" Text='<%#Eval("CreatedBy") %>' runat="server" Visible="false"></asp:Label>
                                    <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                                    <asp:Label ID="lblTimeDiff" Text='<%#Eval("createdDateDiff") %>' runat="server" Visible="false"></asp:Label>
                                    <asp:Label ID="lblCreatedDate" runat="server" Text='<%#Eval("CreatedDate") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                        </Columns>
                        <PagerSettings FirstPageText="First" LastPageText="Last" Mode="NumericFirstLast" PageButtonCount="5" />
                    </asp:GridView>
                </div>
            </div>
    </form>
</body>
</html>