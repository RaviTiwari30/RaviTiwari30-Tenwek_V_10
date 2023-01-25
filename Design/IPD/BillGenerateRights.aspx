<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" ClientIDMode="Static" CodeFile="BillGenerateRights.aspx.cs" Inherits="Design_IPD_BillGenerateRights" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>IPD Bill Generate User Authorization</b><br />

            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />


        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Login Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlLoginType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlLoginType_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Employee&nbsp;<asp:CheckBox ID="chkSelectAll" runat="server"
                                    AutoPostBack="false" Font-Bold="True" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-13">
                            <asp:CheckBoxList ID="chkEmployee" runat="server" RepeatColumns="4" RepeatDirection="Horizontal">
                             
                        </asp:CheckBoxList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" value="Save" onclick="return save()" class="ItDoseButton" id="btnSave" />
        </div>
        <script type="text/javascript">
            function save() {

                if ($("#<%= chkEmployee.ClientID%> input[type=checkbox]:checked").length == "0") {
                    $("#<%=lblMsg.ClientID%>").text('Please Check  Employee');
                    return false;
                }
                $("#<%=lblMsg.ClientID%>").text('');
                $("#btnSave").val('Submitting.....').attr('disabled', 'disabled');
                var selectedValues = [];
                $("#<%= chkEmployee.ClientID %> input:checkbox:checked").each(function () {
                    selectedValues.push($(this).val());
                });
                var RoleID = $("#<%=ddlLoginType.ClientID%>").val();
                if (selectedValues.length > 0) {
                    $.ajax({
                        type: "POST",
                        url: "BillGenerateRights.aspx/SaveBillAuthorized",
                        data: JSON.stringify({ Values: selectedValues, RoleID: RoleID }),
                        dataType: "json",
                        contentType: "application/json;charset=UTF-8",
                        async: false,
                        success: function (response) {
                            if (response.d == "1")
                                DisplayMsg('MM01', 'lblMsg');
                            else
                                DisplayMsg('MM05', 'lblMsg');
                            $("#btnSave").val('Save').removeAttr('disabled');
                        },
                        error: function (xhr, status) {
                            DisplayMsg('MM05', 'lblMsg');

                        }

                    });
                } else {
                    $("#btnSave").val('Save').removeAttr('disabled');
                    $("#<%=lblMsg.ClientID%>").text('Please Check  Employee');
                }
            }
            $(function () {
                $("#<%=chkSelectAll.ClientID%> ").bind("click", function () {
                   if ($(this).is(":checked")) {
                       $("#<%= chkEmployee.ClientID%> input[type=checkbox]").attr("checked", "checked");
                    }
                    else {
                        $("#<%= chkEmployee.ClientID%> input[type=checkbox]").removeAttr("checked");
                    }
               });
               $("#<%= chkEmployee.ClientID%>").bind("click", function () {
                   if ($("#<%= chkEmployee.ClientID%> input[type=checkbox]:checked").length == $("#<%= chkEmployee.ClientID%> input[type=checkbox]").length) {
                        $("#<%=chkSelectAll.ClientID%> ").attr("checked", "checked");
                    } else {
                        $("#<%=chkSelectAll.ClientID%> ").removeAttr("checked");
                    }
                });

           });


            $(function () {

            });
            function loadEmployee() {
                $.ajax({
                    type: "POST",
                    url: "BillGenerateRights.aspx/loadEmployee",
                    data: '{RoleID:"' + $("#<%=ddlLoginType.ClientID%>").val() + '"}',
                   dataType: "json",
                   contentType: "application/json;charset=UTF-8",
                   async: false,
                   success: OnSuccess,

                   failure: function (response) {
                       alert(response.d);
                   },
                   error: function (response) {
                       alert(response.d);
                   }

               });
           }
           function OnSuccess(r) {
               var emp = r.d;
               var repeatColumns = parseInt("<%=chkEmployee.RepeatColumns%>");
                if (repeatColumns == 0) {
                    repeatColumns = 1;
                }
                var cell = $("[id*=chkEmployee] td").eq(0).clone(true);
                $("[id*=chkEmployee] tr").remove();
                $.each(emp, function (i) {
                    var row;
                    if (i % repeatColumns == 0) {
                        row = $("<tr />");
                        $("[id*=chkEmployee] tbody").append(row);
                    } else {
                        row = $("[id*=chkEmployee] tr:last-child");
                    }

                    var checkbox = $("input[type=checkbox]", cell);

                    //Set Unique Id to each CheckBox.
                    checkbox[0].id = checkbox[0].id.replace("0", i);

                    //Give common name to each CheckBox.
                    checkbox[0].name = "Employee_ID";

                    //Set the CheckBox value.
                    checkbox.val(this.Value);

                    var label = cell.find("label");
                    if (label.length == 0) {
                        label = $("<label />");
                    }

                    //Set the 'for' attribute of Label.
                    label.attr("for", checkbox[0].id);

                    //Set the text in Label.
                    label.html(this.Text);

                    //Append the Label to the cell.
                    cell.append(label);

                    //Append the cell to the Table Row.
                    row.append(cell);
                    cell = $("[id*=chkEmployee] td").eq(0).clone(true);
                });
            }
        </script>
    </div>
</asp:Content>

