<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CPOE_MenuMaster.aspx.cs" Inherits="Design_CPOE_CPOE_MenuMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.tablednd.js"></script>
    <div id="Pbody_box_inventory">
         <cc1:ToolkitScriptManager ID="sc" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>CPOE Menu Ordering</b>
            <br /> 
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />

        </div>
         <div class="POuter_Box_Inventory" >
               <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-4">
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">
                                Role
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlRole" runat="server"   ClientIDMode="Static" onchange="bindAllMenu()"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-7">
                            <asp:RadioButtonList ID="rbtType" runat="server" ClientIDMode="Static" onchange="bindAllMenu()" RepeatDirection="Horizontal" >
                                <asp:ListItem Value="1" Selected="True">CPOE Menu</asp:ListItem>
                                 <asp:ListItem Value="2">Prescription Tab</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-8">
                        </div>
                       
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
             </div>
        <asp:Panel ID="pnlMenu" ClientIDMode="Static" style="display:none" runat="server">
             <div class="POuter_Box_Inventory" id="divMenu"   >
             <div class="Purchaseheader">
                     Menu Detail
                </div>

             <table style="width: 100%" id="myTable">
                <tr >
                    <td colspan="4">
                        <div id="MenuOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
                       
                       
                    </td>
                </tr>
            </table>
             </div>
              <div class="POuter_Box_Inventory" style="text-align:center;" id="divMenu1">
            <input type="button" value="Save" id="btnSaveMenu" class="ItDoseButton" onclick="saveMenuTable()" />
        </div>
                 </asp:Panel>
        </div>
    <script type="text/javascript">
        $(function () {
            bindAllMenu();
        });
        function bindAllMenu() {
            $.ajax({
                type: "POST",
                data: '{RoleID:"' + $("#<%=ddlRole.ClientID %>").val() + '", type:"' + Number($('#rbtType input:checked').val()) + '"}',
                url: "CPOE_MenuMaster.aspx/bindAllMenu",
              dataType: "json",
              contentType: "application/json;charset=UTF-8",
              timeout: 120000,
              async: false,
              success: function (result) {
                  CPOEMenu = jQuery.parseJSON(result.d);
                  if (CPOEMenu != null) {
                      var output = $('#tb_Menu').parseTemplate(CPOEMenu);
                      $('#MenuOutput').html(output);
                      $('#MenuOutput,#pnlMenu').show();

                  }
                  else {
                      $('#MenuOutput').html();
                      $('#MenuOutput,#pnlMenu').hide();

                  }
                  condition();

                  $('#tb_grdMenu').tableDnD({
                      onDragClass: "myDragClass",

                      onDragStart: function (table, row) {

                          $("#lblMenuError").html("Started dragging row " + row.id);
                      },
                      dragHandle: ".dragHandle"

                  });


              },
              error: function (xhr, status) {
                  window.status = status + "\r\n" + xhr.responseText;

                  $("#lblMenuError").text('Error occurred, Please contact administrator');

              }

          });
      }
      function condition() {
          if ($('#tb_grdMenu tr').length > 0) {
              $("#divMenu").show(); $("#divMenu1").show();
              $("#btnSaveMenu").removeAttr('disabled');
          }
          else {
              $("#btnSaveMenu").attr('disabled', 'disabled');
              $("#divMenu,#divMenu1").hide(); 
          }
      }
      $(function () {
          bindAllMenu();
      });
      function chngcurmove() {
          document.body.style.cursor = 'move';
      }
   </script>
        <script id="tb_Menu" type="text/html">
    <table  cellspacing="0" rules="all" border="1" id="tb_grdMenu"
        style="border-collapse:collapse;"  class="GridViewStyle">
            <tr id="Header">        
                <th class="GridViewHeaderStyle" scope="col" style="width:30px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:320px;">Menu Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Sequence No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:190px;">Active</th>
                 <th class="GridViewHeaderStyle" scope="col" style="width:190px; display:none">MenuID</th>
					        
            </tr>
            <#       
            var dataLength=CPOEMenu.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {       
            objRow = CPOEMenu[j];
        #>
                    <tr id="<#=j+1#>">                                                                                                                  
                    <td class="GridViewLabItemStyle" id="tdSNo"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdMenuName" onmouseover="chngcurmove()"  style="width:320px;" ><#=objRow.MenuName#></td>
                    <td class="GridViewLabItemStyle" id="tdSeqNo" onmouseover="chngcurmove()" style="width:60px; text-align:center " ><#=objRow.SequenceNo#></td>
                    <td class="GridViewLabItemStyle" id="tdActive"  style="width:190px; text-align:center;cursor:pointer">
                        <input type="radio" value="1" id="rdoActive"  name="<#=j+1#>"
                             <#if(objRow.IsActive=="1"){#> 
                        checked="checked"  <#} #>                            
                             ><#=objRow.Active#> </input> <input type="radio" value="0" id="rdoDeActive"  name="<#=j+1#>"
                                  <#if(objRow.IsActive=="0"){#> 
                        checked="checked"  <#} #> ><#=objRow.DeActive#></input>
                        </td>
                    <td class="GridViewLabItemStyle" id="tdID"  style="width:60px; display:none" ><#=objRow.Id#></td>

                        
                    </tr>           
        <#}       
        #>       
     </table>    
    </script>
    <script type="text/javascript">
        function saveMenuTable() {
            $("#btnSaveMenu").attr('disabled', 'disabled');
            if ($('#tb_grdMenu tr').length > 0) {
                var CPOE = [];
                $("#tb_grdMenu tr").each(function () {
                    var id = $(this).attr("id");
                    var $rowid = $(this).closest("tr");
                    if (id != "Header") {
                        CPOE.push({ "SNo": $(this).attr("id"), "ID": $.trim($rowid.find("#tdID").text()), "MenuName": $.trim($rowid.find("#tdMenuName").text()), "SequenceNo": $.trim($rowid.find('#tdSeqNo').text()), "Active": $.trim($rowid.find('#tdActive input[type:radio]:checked').val()) });
                    }
                });
                if (CPOE.length > "0") {
                    $.ajax({
                        type: "POST",
                        data: JSON.stringify({ CPOE: CPOE, RoleID: $("#<%=ddlRole.ClientID %>").val(), type:Number($('#rbtType input:checked').val()) }),
                        url: "CPOE_MenuMaster.aspx/saveCPOETable",
                        dataType: "json",
                        contentType: "application/json;charset=UTF-8",
                        timeout: 120000,
                        async: false,
                        success: function (result) {
                            CPOEResult = (result.d);
                            if (CPOEResult == "1") {
                              
                                $("#lblMsg").text('Record Saved Successfully');
                               
                            }
                            else {
                               
                                $("#lblMsg").text('Error occurred, Please contact administrator');
                               
                            }
                            bindAllMenu();
                            $("#btnSaveMenu").removeAttr('disabled');
                        },
                        error: function (xhr, status) {
                            window.status = status + "\r\n" + xhr.responseText;
                            $("#lblMsg").text('Error occurred, Please contact administrator');
                            $("#btnSaveMenu").removeAttr('disabled');
                           
                        }

                    });
                }
            }
        }
    </script>
</asp:Content>

