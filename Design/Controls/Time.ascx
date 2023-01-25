<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Time.ascx.cs" Inherits="Design_Controls_Time" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:TextBox ID="txtTime" runat="server" TabIndex="2" ToolTip="Enter Time" CssClass="ItDoseTextinputText"
    Width="82px" MaxLength="5" />
      <em ><span style="color: #0000ff; font-size: 7.5pt">
                       (Type A or P to switch AM/PM)</span></em>
<cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
    TargetControlID="txtTime"  AcceptAMPM="True">
</cc1:MaskedEditExtender>
<cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
    ControlExtender="masTime" IsValidEmpty="true" EmptyValueMessage="Time Required"
    InvalidValueMessage="Invalid Time"  ></cc1:MaskedEditValidator>
