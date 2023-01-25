<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="CategoryLabRole.aspx.cs" Inherits="Design_EDP_CategoryLabRole" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
         <script  type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(function () {
            $("#<%=chkSelectAll.ClientID%> ").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("#<%= chkObservationType.ClientID%> input[type=checkbox]").attr("checked", "checked");
                    $(this).siblings('label').html('De-Select All');
                }
                else {
                    $("#<%= chkObservationType.ClientID%> input[type=checkbox]").removeAttr("checked");
                    $(this).siblings('label').html('Select All');
                }
            });
            $("#<%= chkObservationType.ClientID%>").bind("click", function () {
                if ($("#<%= chkObservationType.ClientID%> input[type=checkbox]:checked").length == $("#<%= chkObservationType.ClientID%> input[type=checkbox]").length) {
                    $("#<%=chkSelectAll.ClientID%> ").attr("checked", "checked");
                    $("#<%=chkSelectAll.ClientID%> ").siblings('label').html('De-Select All');
                } else {
                    $("#<%=chkSelectAll.ClientID%> ").removeAttr("checked");
                    $("#<%=chkSelectAll.ClientID%> ").siblings('label').html('Select All');
                }
            });

        });

        function validate() {
            if ($("#<%= chkObservationType.ClientID%> input[type=checkbox]:checked").length == "0") {
                $("#<%=lblMsg.ClientID%>").text('Please Check  Department');
                return false;

            }
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }
        $(function () {
            LoadObservationTypes();
        });
        function LoadObservationTypes() {
            $.ajax({
                type: "POST",
                url: "Services/EDP.asmx/LoadObservationTypes",
                data: '{RoleID:"' + $("#<%=ddlLoginType.ClientID%>").val() + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    ObservationTypes = jQuery.parseJSON(response.d);
                    if (ObservationTypes != null) {
                        var list = $('#<%= chkObservationType.ClientID%> input:checkbox');
                        for (i = 0; i < ObservationTypes.length; i++) {
                          
                            if (list[i].value == ObservationTypes[i].ObservationType_ID) {
                                if (ObservationTypes[i].isExist == "true") {
                                    list[i].checked = true;
                                    
                                }
                                else {
                                    list[i].checked = false;
                                    
                                }
                            }
                           
                            
                        }
                    }
                    else {

                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblMsg');
                    window.status = status + "\r\n" + xhr.responseText;

                }

            });
        }

        function saveInv() {
            $("#<%=lblMsg.ClientID%>").text('');
            $("#btnSave1").attr('disabled', 'disabled');
            var selectedItems = []; var selectedValues = [];
            $("#<%= chkObservationType.ClientID %> input:checkbox:checked").each(function () {
               
                selectedItems.push ($(this).next().html());
                selectedValues.push($(this).val());
                
            });
            var RoleID = $("#<%=ddlLoginType.ClientID%>").val();
            var RoleName = $("#<%=ddlLoginType.ClientID%> option:selected").text();
            if (selectedItems.length > 0) {
                $.ajax({
                    type: "POST",
                    url: "Services/EDP.asmx/SaveObservationTypes",
                    data: JSON.stringify({ Items: selectedItems, Values: selectedValues, RoleID: RoleID, RoleName: RoleName }),
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: false,
                    success: function (response) {
                        if (response.d=="1")
                            DisplayMsg('MM01', 'lblMsg');
                        else
                            DisplayMsg('MM05', 'lblMsg');
                        $("#btnSave1").removeAttr('disabled');
                    },
                    error: function (xhr, status) {
                        DisplayMsg('MM05', 'lblMsg');
                        window.status = status + "\r\n" + xhr.responseText;

                    }

                });
            } else {
                $("#btnSave1").removeAttr('disabled');
                $("#<%=lblMsg.ClientID%>").text('Please Check  Department');
            }
        }
    </script>
    
            <div id="Pbody_box_inventory">
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    
                        <b>Bind Investigation Group with Department</b><br />
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
                   
                </div>
                <div class="POuter_Box_Inventory">
                    <table style="width: 500px"  border="0">
                        <tbody>
                            <tr>
                                <td style="width: 34%; text-align: right">
                                    Login Type : &nbsp;
                                </td>
                                <td colspan="2" style=" text-align:left">
                                    <asp:DropDownList ID="ddlLoginType" runat="server" onchange="LoadObservationTypes()" AutoPostBack="false" OnSelectedIndexChanged="ddlLoginType_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Remove Selection To De-Activate&nbsp;<asp:CheckBox ID="chkSelectAll" runat="server"
                            AutoPostBack="false" Font-Bold="True" OnCheckedChanged="chkSelectAll_CheckedChanged"
                            Text="Select All" /></div>
                     <table style="width:100%"  border="0">
                         <tr>
                             <td style="text-align:left">

                            
                        <asp:CheckBoxList ID="chkObservationType" runat="server" RepeatColumns="4" RepeatDirection="Horizontal"
                            Width="956px">
                        </asp:CheckBoxList>
                                  </td>
                         </tr>
                        </table>
                </div>
                <div class="POuter_Box_Inventory" style="text-align: center">
                    
                        <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton"  Text="Save"
                            OnClick="btnSave_Click" OnClientClick="return validate()" Visible="false" />
               <input type="button" value="Save" onclick="saveInv()" class="ItDoseButton" id="btnSave1" /> </div>
            </div>
       
</asp:Content>
