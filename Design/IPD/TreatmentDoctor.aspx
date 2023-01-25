<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TreatmentDoctor.aspx.cs" Inherits="TreatmentDoctor" %>

<%@ Register Src="~/Design/Controls/StartDateTime.ascx" TagName="StartDate" TagPrefix="uc1" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagName="StartDate" TagPrefix="uc2" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Room Billing</title>
    <style type="text/css">
        .style1
        {
            width: 120px;
        }
    </style>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
 <script type ="text/javascript" >
     function RestrictDoubleEntry(btn) {
        // if ($("#<%=ddlDoc.ClientID %> option:selected").text() == "Select") {
          //   $("#<%=lblmsg.ClientID %>").text('Please Select Doctor');
            // $("#<%=ddlDoc.ClientID %>").focus();
             //return false;
         //}
         btn.disabled = true;
         btn.value = 'Submitting...';
         __doPostBack('btnShift', '');
     }

     //function bindTeamlist() {
     //    serverCall('TreatmentDoctor.aspx/bindDoctorTeamList', { TeamID: $('#ddlDoc').val() }, function (response) {
     //        var responseData = JSON.parse(response);
     //        if (responseData.status) {
     //            var $ddlDoctorTeamList = $('#ddlDoctorTeamList');
     //            $ddlDoctorTeamList.bindDropDown({ defaultValue: 'Select', data: responseData.response, valueField: 'DoctorID', textField: 'DoctorName' });
     //        }

     //        else { $('#ddlDoctorTeamList').empty(); }
     //    });
     //}
    </script>
    <form id="form1" runat="server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="content" style="text-align: center;">
                &nbsp;<b>Doctor Shifting</b>
                <br />
                <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Doctor Team</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                   <asp:DropDownList ID="ddlDoc" ToolTip="Select Doctor" runat="server"  ClientIDMode="Static" AutoPostBack="true" OnSelectedIndexChanged="ddlDoc_SelectedIndexChanged"/>
                </div>
                <div class="col-md-3">
                       <label class="pull-left">First Call</label>
                    <b class="pull-right">:</b>
                </div>
                 <div class="col-md-4">
                   <asp:DropDownList ID="ddlDoctorTeamList" ToolTip="Select Doctor" runat="server" ClientIDMode="Static"  />
                </div>
                 <div class="col-md-3">
                       <label class="pull-left">Shift Date & Time </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-7">
                     <uc1:StartDate ID="txtDate" runat="server" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Change Team</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                   <asp:CheckBox  ID="chkChangeTeam" runat="server" />
                </div>
                <div class="col-md-3">
                       <label class="pull-left">Change First Call</label>
                    <b class="pull-right">:</b>
                </div>
                 <div class="col-md-4">
                   <asp:CheckBox  ID="chkFirstCall" runat="server" />
                </div>
                 <div class="col-md-3">
                 
                </div>
                <div class="col-md-7">
                     
                </div>
            </div>
            
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <asp:Button ID="btnShift" runat="server" CssClass="ItDoseButton" Text="Shift" OnClick="btnShift_Click" OnClientClick="return RestrictDoubleEntry(this);"/>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; <span style="background-color: #99FFCC">
                    &nbsp;Status In</span>&nbsp;&nbsp; <span style="background-color: #FF99CC">Status Out</span>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Doctor Shift Details
            </div>
            <div class="content" style="text-align: center;overflow-y:scroll;height:300px;width:99%">
                <asp:GridView ID="grdDocDetail" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                    OnRowDataBound="grdDocDetail_RowDataBound">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Team" HeaderText="Team" HeaderStyle-Width="150px"
                            ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                              <asp:BoundField DataField="FirstCall" HeaderText="FirstCall" HeaderStyle-Width="150px"
                            ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                        <asp:BoundField DataField="EntryDate" HeaderText="Entry Date" HeaderStyle-Width="180px"
                            ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                        <asp:BoundField DataField="LeaveDate" HeaderText="Leave Date" HeaderStyle-Width="180px"
                            ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                        <asp:BoundField DataField="Name" HeaderText="User" HeaderStyle-Width="140px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle" />
                        <asp:TemplateField HeaderText="Status" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
    <asp:Label ID="lblPanelID" runat="server" Visible="False"></asp:Label>
    <asp:Label ID="lblPatientID" runat="server" Visible="False"></asp:Label>
    <asp:Label ID="lblTransactionNo" runat="server" Visible="False"></asp:Label>&nbsp;
    <asp:Label ID="lbl" runat="server" Visible="False"></asp:Label>
    <div class="content" style="text-align: center">
    </div>
    </form>
</body>
</html>
