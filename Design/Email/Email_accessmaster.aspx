<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Email_accessmaster.aspx.cs" Inherits="Design_Email_Email_accessmaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
    <script type="text/javascript" src="../../Scripts/json2.js"></script>
    <div id="Pbody_box_inventory">
        <ajax:scriptmanager ID="ScriptManager1" runat="server" EnablePageMethods="true"></ajax:scriptmanager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Email  Master</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Email Master</div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
          Template Name</label><b class="pull-right">:</b></div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlTemplate" runat="server" ToolTip="Select Sets" ClientIDMode="Static">
                        </asp:DropDownList>
                          <span id="spnID" style="display:none"></span>   
                        <asp:HiddenField id="htnid" runat="server" />
                        </div>
                        <div class="col-md-3"></div>
                        <div class="col-md-3">
                            <label class="pull-left">Email To</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">              
                        <asp:DropDownList ID="ddlEmailto" runat="server" ClientIDMode="Static" >
                          <asp:ListItem Value="0" Text="-----Select-----"></asp:ListItem>
                           <asp:ListItem Value="2" Text="Employee"></asp:ListItem>
                           <asp:ListItem Value="3" Text="Other"></asp:ListItem>
                      </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                        </div>
                        <div class="col-md-5"></div>
                    </div>
                    <div class="row" id="emailname">
                        <div class="col-md-3">
                            <label class="pull-left">Email To Name</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlEmp" runat="server" ClientIDMode="Static">
                        </asp:DropDownList>
                         <asp:TextBox runat="server" ID="txtother" ClientIDMode="Static" Style="display:none;" AutoCompleteType="Disabled"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <input type="button" id="btnadd" value="Add" class="ItDoseButton" onclick="AddEmployee()" />
                        </div>
                    </div>
                </div><div class="col-md-1"></div></div>
              <table style="width: 100%; border-collapse: collapse">
            <tr style="text-align: center">
                <td>
                    <table class="GridViewStyle" rules="all" border="1" id="tb_grdEmployeeSearch"
                        style="width: 57%; border-collapse: collapse; display: none; height: 2px; overflow: scroll">
                        <tr id="Header"><th class="GridViewHeaderStyle" scope="col" style="width: 10px; display: none">S.No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 10px; display: none">ID</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Employee</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 5px;">Remove</th></tr>
                    </table>
                </td>
            </tr>
        </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
          <%--  <input type="button" class="ItDoseButton" id="btnSearch" onclick="search()" value="Search" />--%>
            <%--<asp:Button ID="btnSave" CssClass="ItDoseButton" runat="server" OnClientClick="return Validation()" Text="Save" OnClick="btnSave_Click"/>--%>
            <input type="button" class="ItDoseButton" id="Btnsearch"  value="Save" onclick="savedetails()"  />
               <input type="button" class="ItDoseButton" id="btnupdate"  value="Update" style="display:none" onclick="UpdateDetails()"  />
        </div>
          <div class="POuter_Box_Inventory" id="divINV">
             <div class="Purchaseheader">
                     Search Result
                </div>

             <table cellpadding="0" cellspacing="0" style="width: 100%" id="myTable">
                <tr >
                    <td colspan="4">
                        <div id="SearchOutput" style="max-height: 470px; overflow-x: auto;">
                        </div>
                       
                       
                    </td>
                </tr>
            </table>
             </div>
      
        <div class="POuter_Box_Inventory hide" style="text-align: center; display: none;">
         <%--   <input type="button" class="ItDoseButton" id="btnSave" onclick="Save()" value="Save" />--%>
        </div>
    </div>
    <script type="text/javascript">
        function LoadTemplate() {
            jQuery.ajax({
                url: "Email_accessmaster.aspx/loadSets",
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    Data = jQuery.parseJSON(result.d);
                  
                    $("#<%=ddlTemplate.ClientID %>").empty().append('<option selected="selected" value="0">Select</option>');
                        for (i = 0; i < Data.length; i++) {
                            $("#<%=ddlTemplate.ClientID %>").append($("<option></option>").val(Data[i].ID).html(Data[i].TemplateName));
                        }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        $(document).ready(function () {

            LoadTemplate();
            BindDetails();
        });

        $('#ddlEmailto').change(function () {
            var Email = $("#ddlEmailto").val();
           
            if (Email == 2)
            {
                jQuery.ajax({
                    url: "Email_accessmaster.aspx/LoadEmpolyee",       
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    success: function (result) {
                        Data = jQuery.parseJSON(result.d);
                       
                        $("#<%=ddlEmp.ClientID %>").empty().append('<option selected="selected" value="0">Select</option>');
                            for (i = 0; i < Data.length; i++) {
                                $("#<%=ddlEmp.ClientID %>").append($("<option></option>").val(Data[i].EmployeeID).html(Data[i].Name));
                       
                    }
                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
                $("#txtother").hide();
                $("#ddlEmp").show();
                $("#txtother").val('');
                $("#btnadd").show();
                $('#ddlEmp').removeAttr("disabled");
                $("#emailname").show();
            }
            if (Email == 3)
            {
                $("#<%=ddlEmp.ClientID %>").hide();
                $("#txtother").show();
                $("#btnadd").show();
                $("#emailname").show();
            }
            if (Email == 1)
            {
              
                $("#emailname").hide();
                $("#tb_grdEmployeeSearch").hide();
                $('#tb_grdEmployeeSearch tbody').remove();
            }
        });
        function AddEmployee() {
            var Employee = "";
            var ID = "";
            var EmailTo = "";
             EmailTo = $("#ddlEmailto").val();
            if (EmailTo == '0')
            {
                alert('Select the Email Name To');
                return;
            }
            if (EmailTo == "1") {
                Employee = "";
                ID = "";
            }
            if (EmailTo == "2") {
                Employee = $("#ddlEmp option:selected").text();
                ID = $("#ddlEmp option:selected").val();
                 EmailTo = $("#ddlEmailto").val();
                if (ID == "0")
                {
                    alert('Select the Email Name To');
                    return;
                }
            }
            if (EmailTo == "3") {

                Employee = $("#txtother").val();
                if (Employee == "")
                {
                    alert('Please Enter the Email To Name');
                    return;
                }
                if (!ValidateEmail($("#txtother").val())) {
                    alert("Invalid email address.");
                    return;
                }
                ID = "";
            }
            // var Employeetext = $("#txtother").val();

            function ValidateEmail(email) {
                var expr = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
                return expr.test(email);
                
            };
            RowCount = $("#tb_grdEmployeeSearch tr").length;
            RowCount = RowCount + 1;

            var AlreadySelect = 0;

            if (RowCount > 2) {

                $("#tb_grdEmployeeSearch tr").each(function () {
                    if ($(this).attr("id") == 'tr_' + ID) {
                        AlreadySelect = 1;
                        return;
                    }
                });
            }
            if (AlreadySelect == "0") {
                var newRow = $('<tr />').attr('id', 'tr_' + ID)
                newRow.html('<td class="GridViewLabItemStyle" style="display:none;">' + (RowCount - 1) +
                     '</td><td class="GridViewLabItemStyle" style="display:none;" id=td_ID >' + ID +
                      '</td><td class="GridViewLabItemStyle" style="display:none;" id=td_Email >' + EmailTo +
                     '</td><td class="GridViewLabItemStyle" style="text-align:centre" id=td_Name >' + Employee +
                     '</td><td class="GridViewLabItemStyle" style="text-align:center"><img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteRow(this);"   title="Click To Remove" /></td>'
                    );
                $("#tb_grdEmployeeSearch").append(newRow);
                $("#tb_grdEmployeeSearch").show();
            }
            else {
               
                alert('Employee Already Selected');
            }

        }
        function BindDetails() {
            $.ajax({
                type: "POST",
                url: "Email_accessmaster.aspx/BindEmailMaster",
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                timeout: 120000,
                async: false,
                success: function (result) {
                    MyDate = jQuery.parseJSON(result.d);
                    if (MyDate != null) {
                        var output = $('#tb_Search').parseTemplate(MyDate);
                        $('#SearchOutput').html(output);
                        $('#SearchOutput').show();
                    }
                    else {
                        $("#lblMsg").text('');
                    }

                    $("#btnSearch").removeProp('disabled');
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $("#lblMsg").text('Error occurred, Please contact administrator');
                    $("#btnSearch").removeProp('disabled');
                    $("#debugArea").html("");
                }

            });
        }
           
        
        function DeleteRow(rowid) {
            var row = rowid;
            $(row).closest('tr').remove();
        }
        function Employee() {
            var dataEmp = new Array();
            var ObjEmp = new Object();
            jQuery("#tb_grdEmployeeSearch tr").each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");
                if (id != "Header" && typeof(id) !='undefined' ) {
                    ObjEmp.Id = jQuery.trim($rowid.find("#td_ID").text());
                    ObjEmp.Employeename = jQuery.trim($rowid.find("#td_Name").text());
                    ObjEmp.EmployeeType = jQuery.trim($rowid.find("#td_Email").text());
                    dataEmp.push(ObjEmp);
                    ObjEmp = new Object();
                }

            });
            return dataEmp;
        }
        function Edit(rowid) {
            if ($('#tb_grdEmployeeSearch tr:not(#Header)').length > 0) {
                $("#tb_grdEmployeeSearch tr:not(#Header)").remove();
            }
            var TemplateId = $(rowid).closest('tr').find("#TemplateId").text();
           
            var ID = $(rowid).closest('tr').find("#ID").text();
            // $("#Btnsearch").html("UpDate");
            $("#btnupdate").show();
            $("#Btnsearch").hide();
            $("#ddlTemplate").val($(rowid).closest('tr').find("#TemplateId").text());
            $("#<%=htnid.ClientID %>").val(TemplateId);
            var ss = $(rowid).closest('tr').find("#txtemailto").text();
            //if (ss == "Patient") {
               // $("#ddlEmailto").val(1);
               // $('#<%=ddlEmp.ClientID %>').attr("disabled", "disabled");
              //  $("#emailname").hide();
              
               // $("#tb_grdEmployeeSearch tbody tr").remove();
            //}
            if (ss == "Employee") {
               // $("#ddlEmailto").val(2);
                jQuery.ajax({
                    url: "Email_accessmaster.aspx/LoadEmpolyee",

                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    success: function (result) {
                        Data = jQuery.parseJSON(result.d);
                        $("#<%=ddlEmp.ClientID %>").empty().append('<option selected="selected" value="0">Select</option>');
                        for (i = 0; i < Data.length; i++) {

                            $("#<%=ddlEmp.ClientID %>").append($("<option></option>").val(Data[i].EmployeeID).html(Data[i].Name));
                            }

                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
                    //$("#txtother").hide();
                    //$("#ddlEmp").show();

                    //$("#ddlEmp").val($(rowid).closest('tr').find("#Email").text());
                    //$('#ddlEmp').removeAttr("disabled");
                    //$("#emailname").show();
                }
                //else {
                //    $("#ddlEmailto").val(3);
                //    $("#txtother").show();
                //    $("#ddlEmp").hide();
                //    $("#txtother").val($(rowid).closest('tr').find("#txtEmail").text());
                //}

            //$("#spnID").text(ID);
            bindDoctor(TemplateId);
         
            
        }
        function savedetails() {
            var Templatename = $("#ddlTemplate").val();
            var EmailTo = $("#ddlEmailto").val();

            var EmailName = $("#ddlEmp").val();
           

            if (Templatename == "0") {
                alert('Please Enter The Template Name');
                return;
            }
            if (EmailTo == "0") {
                alert('Select the Email To');
                return;
            }
           
            var EmployeeID = Employee();
            if (EmailTo != "1") {
                if ($("#tb_grdEmployeeSearch tr").length == "1") {
                    alert('Please Add the Email To Name');
                    $('#ddlEmp').focus();
                    Val = 1;
                    return false;
                }
            }
            $.ajax({
                url: "Email_accessmaster.aspx/SaveEmailMaster",
                data: JSON.stringify({ "TemplateName": Templatename, "EmailName": EmailName, "Employee": EmployeeID }),
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: "120000",
                dataType: "json",
                async: false,
                success: function (result) {
                    var OutPut = result.d;
                    if (OutPut == "1") {
                        window.location.reload(0);
                        $('#lblMsg').text('Record Save Successfully');
                        BindDetails();
                        $("#tb_grdEmployeeSearch").hide();
                        $("#tb_grdEmployeeSearch tbody").empty();
                        $("#ddlTemplate").val(0);
                        $("#ddlEmailto").val(0);
                        $("#ddlTemplate").val(0);
                    }
                    else if (OutPut == "3") {
                        $('#lblMsg').text('Patient Name Already Added');
                    }
                    else if (OutPut == "2") {
                        $('#lblMsg').text('Employee already add under the same template name');
                    }
                    else {
                        $('#lblMsg').text('EmailTO Already Add under the Template Name');
                        $("#tb_grdEmployeeSearch").hide();
                        $("#tb_grdEmployeeSearch tbody").empty();
                    }
                },
                error: function (xhr, status) {
                    $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                }
            });


        }
        function UpdateDetails() {
            var Templatenametype = $("#ddlTemplate").val();
            var EmailTO = $("#ddlEmailto").val();
            var Email = Employee();
            var TemplateId = $("#<%=htnid.ClientID %>").val();
            var ID = $("#spnID").text();
            $.ajax({
                url: "Email_accessmaster.aspx/UpdateType",
                data: JSON.stringify({ "Templatenametype": Templatenametype, "Email": Email, "ID": TemplateId }),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        window.location.reload(0);
                        $('#lblMsg').text('Record Update Successfully');
                        $("#tb_grdEmployeeSearch").empty();
                        $("#ddlTemplate").val(0);
                        $("#ddlEmailto").val(0);
                        $("#ddlTemplate").val(0);
                        $("#txtother").val('');
                        BindDetails();
                    }
                    $("#btnUpdate").removeAttr('disabled');
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;                   
                }
            });
            $("#tb_grdEmployeeSearch").hide();
        }

        function bindDoctor(TemplateId) {
            $.ajax({
                url: "Email_accessmaster.aspx/BindEmailTo",
                data: '{TemplateId:"' + TemplateId + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: true,
                success: function (result) {
                  var  PatientData = jQuery.parseJSON(result.d);
                    if (PatientData != null) {
                        for (i = 0; i < PatientData.length; i++) {
                                var RowCount = $("#tb_grdEmployeeSearch tr").length;
                                RowCount = RowCount + 1;
                                var newRow = $('<tr />').attr('id', 'tr_' + PatientData[i].EmployeeID)
                                newRow.html('<td class="GridViewLabItemStyle" style="display:none;">' + (RowCount - 1) +
                                     '</td><td class="GridViewLabItemStyle" style="display:none;" id=td_ID >' + PatientData[i].EmployeeID +
                                     '</td><td class="GridViewLabItemStyle" style="display:none;" id=td_Email >' + PatientData[i].EmailTo +
                                     '</td><td class="GridViewLabItemStyle" style="text-align:centre" id=td_Name >' + PatientData[i].Name +
                                     '</td><td class="GridViewLabItemStyle" style="text-align:center"><img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteRow(this);"  onmouseover="chngcur()" title="Click To Remove" /></td>'
                                    );
                                $("#tb_grdEmployeeSearch").append(newRow);
                                $("#tb_grdEmployeeSearch").show();
                        }
                    }
                    else {
                        $("#tb_grdEmployeeSearch").hide();
                    }
                },
                error: function (xhr, status) {
                    alert(status + "\r\n" + xhr.responseText);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });

        }
    </script>
    <script id="tb_Search" type="text/html">
    <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table1" style="width:100%;border-collapse:collapse;">
		<tr id="Tr1">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">Sno</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:160px;">TemplateName</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:79px;">EmailTo</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:19%;">Email</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:19%;display:none" >EmailID</th>
		    <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Edit</th>
		</tr>

        <#
       
         var dataLength=MyDate.length;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {

        objRow = MyDate[j];
        
          #>
                   <tr>
                       
                      <td  class="GridViewLabItemStyle"  ><#=j+1#></td>
                        <td id="ID" class="GridViewLabItemStyle"  style="display:none"><#=objRow.ID#></td>
                       
                        <td id="templatename" class="GridViewLabItemStyle"><#=objRow.TemplateName#></td>
                      
                        
                         <td  id="txtemailto" class="GridViewLabItemStyle"><#=objRow.EmailTO#></td>
                        <td  id="txtEmail" class="GridViewLabItemStyle"><#=objRow.Name#></td>
                       
                       <td  id="Email" class="GridViewLabItemStyle" style="display:none"><#=objRow.EmployeeID#></td>
                        <td  id="TemplateId" class="GridViewLabItemStyle" style="display:none"><#=objRow.TemplateID#></td>
                     <td class="GridViewLabItemStyle" id="tdDelete" style="text-align:center;">
                    <img id="imgRmv" src="../../Images/edit.png" onclick="Edit(this)"  title="Edit"/>
                    </td>
                   
        
        

                </tr>   
            <#}#>
     </table>    
    </script>
</asp:Content>


